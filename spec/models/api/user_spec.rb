# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User' do
  describe '#get_list' do
    subject { Api::User.get_list(access_token:) }

    context 'アクセストークンがない場合' do
      let(:access_token) { nil }

      it 'errorsが返る' do
        expect(subject).to include Api::Error
      end
    end

    context 'アクセストークンがある場合' do
      let(:current_user) { create(:user, :admin) }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }

        it 'errorsが返る' do
          expect(subject).to include Api::Error
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        it 'ユーザの配列が返る' do
          expect(subject).to include Api::User
        end
      end
    end
  end

  describe '#destroy' do
    subject { Api::User.destroy(access_token:, id:) }

    let(:target_user) { create(:user) }
    let(:current_user) { create(:user, :admin) }

    let(:valid_token) { AccessToken.new(email: current_user.email).encode }

    before { WebMock.enable! }

    context 'アクセストークンがない場合' do
      before do
        WebMock
          .stub_request(:delete, "http://localhost:3000/api/users/#{id}")
          .to_return(
            body:   {
              errors: [
                {
                  name:    'access_token',
                  message: 'authentication token is missing'
                }
              ]
            }.to_json,
            status: 400
          )
      end

      let(:access_token) { nil }
      let(:id) { target_user.id }

      it 'エラーの入った配列が返る' do
        expect(subject).to include Api::Error
        expect(WebMock).to have_requested(:delete, "http://localhost:3000/api/users/#{id}")
      end
    end

    context 'アクセストークンがある場合' do
      let(:current_user) { create(:user, :admin) }

      context 'アクセストークンが有効期限切れの場合' do
        before do
          WebMock
            .stub_request(:delete, "http://localhost:3000/api/users/#{id}")
            .with(headers: { Authorization: "Bearer #{access_token}" })
            .to_return(
              body:   {
                errors: [
                  {
                    token:   'access_token',
                    message: 'Invalid token'
                  }
                ]
              }.to_json,
              status: 401
            )
        end

        let(:access_token) { expired_access_token(email: current_user.email) }
        let(:id) { target_user.id }

        it 'エラーの入った配列が返る' do
          expect(subject).to include Api::Error
          expect(WebMock).to have_requested(:delete, "http://localhost:3000/api/users/#{id}")
                               .with(headers: { Authorization: "Bearer #{access_token}" })
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { valid_token }

        context '自分のIDを指定した場合' do
          let(:id) { current_user.id }

          before do
            WebMock
              .stub_request(:delete, "http://localhost:3000/api/users/#{id}")
              .with(headers: { Authorization: "Bearer #{access_token}" })
              .to_return(
                body:   {
                  errors: [
                    {
                      name:    'user_id',
                      message: "You can't delete yourself"
                    }
                  ]
                }.to_json,
                status: 401
              )
          end

          it 'エラーの入った配列が返る' do
            expect(subject).to include Api::Error
            expect(WebMock).to have_requested(:delete, "http://localhost:3000/api/users/#{id}")
                                 .with(headers: { Authorization: "Bearer #{access_token}" })
          end
        end

        context '自分以外のIDを指定した場合' do
          let(:id) { target_user.id }

          before do
            WebMock
              .stub_request(:delete, "http://localhost:3000/api/users/#{id}")
              .with(headers: { Authorization: "Bearer #{access_token}" })
              .to_return(
                status: 204
              )
          end

          it 'trueが返る' do
            expect(subject).to be_truthy
            expect(WebMock).to have_requested(:delete, "http://localhost:3000/api/users/#{id}")
                                 .with(headers: { Authorization: "Bearer #{access_token}" })
          end
        end
      end
    end
  end
end
