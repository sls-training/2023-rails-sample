# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User' do
  describe '#get_list' do
    subject { Api::User.get_list(access_token:) }

    let(:limit) { 50 }
    let(:sort_key) { 'name' }
    let(:order_by) { 'asc' }
    let(:offset) { 0 }

    context 'アクセストークンがない場合' do
      let(:access_token) { nil }

      before do
        WebMock
          .stub_request(:get, 'http://localhost:3000/api/users')
          .with(query: { limit:, offset:, order_by:, sort_key: })
          .to_return(
            body:    {
              errors: [
                {
                  name:    'access_token',
                  message: 'Authentication token is missing'
                }
              ]
            }.to_json,
            status:  400,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it '例外を投げる' do
        expect { subject }.to raise_error Api::Error
        expect(WebMock).to have_requested(:get, 'http://localhost:3000/api/users')
                             .with(query: { limit:, offset:, order_by:, sort_key: })
      end
    end

    context 'アクセストークンがある場合' do
      let(:current_user) { create(:user, :admin) }

      context 'アクセストークンが有効期限切れの場合' do
        before do
          WebMock
            .stub_request(:get, 'http://localhost:3000/api/users')
            .with(
              query:   { limit:, offset:, order_by:, sort_key: },
              headers: { Authorization: "Bearer #{access_token}" }
            )
            .to_return(
              body:   {
                errors: [
                  {
                    name:    'access_token',
                    message: 'Invalid token'
                  }
                ]
              }.to_json,
              status: 401
            )
        end

        let(:access_token) { expired_access_token(email: current_user.email) }

        it '例外を投げる' do
          expect { subject }.to raise_error Api::Error
          expect(WebMock).to have_requested(:get, 'http://localhost:3000/api/users')
                               .with(
                                 query:   { limit:, offset:, order_by:, sort_key: },
                                 headers: { Authorization: "Bearer #{access_token}" }
                               )
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        before do
          WebMock
            .stub_request(:get, 'http://localhost:3000/api/users')
            .with(
              query:   { limit:, offset:, order_by:, sort_key: },
              headers: { Authorization: "Bearer #{access_token}" }
            )
            .to_return(
              body:    User
                       .order(sort_key => order_by)
                       .limit(limit)
                       .offset(offset).map { |user| user_to_api_user(user) }
                       .to_json,
              status:  200,
              headers: { 'Content-Type' => 'application/json' }
            )
        end

        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        it 'ユーザの配列が返る' do
          expect(subject).to include Api::User
          expect(WebMock).to have_requested(:get, 'http://localhost:3000/api/users')
                               .with(
                                 query:   { limit:, offset:, order_by:, sort_key: },
                                 headers: { Authorization: "Bearer #{access_token}" }
                               )
        end
      end
    end
  end

  describe '#destroy' do
    context 'アクセストークンがない場合' do
      xit 'ユーザ削除のAPIを呼び、例外を返す' do
      end
    end

    context 'アクセストークンがある場合' do
      context 'アクセストークンが有効期限切れの場合' do
        xit 'ユーザ削除のAPIを呼び、例外を返す' do
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        context '不正なユーザーidが指定された場合' do
          xit 'ユーザ削除のAPIを呼び、例外を返す' do
          end
        end

        context '正当なユーザーIdが指定された場合' do
          xit 'ユーザ作成のAPIを呼び、trueを返す' do
          end
        end
      end
    end
  end
end
