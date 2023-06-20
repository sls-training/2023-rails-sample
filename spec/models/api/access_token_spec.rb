# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessToken' do
  describe '#create' do
    subject { Api::AccessToken.create(email:, password:) }

    context '管理者でないユーザの場合' do
      let(:no_admin_user) { create(:user, :noadmin) }

      context 'emailがない場合' do
        let(:email) { '' }
        let(:password) { no_admin_user.password }

        before do
          WebMock
            .stub_request(:post, 'http://localhost:3000/api/token')
            .with(body: { email:, password: })
            .to_return(
              body:   {
                errors: [
                  {
                    name:    'access_token',
                    message: 'Incorrect email or password'
                  }
                ]
              }.to_json,
              status: 400
            )
        end

        it '例外を投げる' do
          expect { subject }.to raise_error Api::Error

          expect(WebMock).to have_requested(:post, 'http://localhost:3000/api/token')
                               .with(body: { email:, password: })
        end
      end

      context 'emailがある場合' do
        let(:email) { no_admin_user.email }

        context 'パスワードが間違っている場合' do
          let(:password) { 'wrong_password' }

          before do
            WebMock
              .stub_request(:post, 'http://localhost:3000/api/token')
              .with(body: { email:, password: })
              .to_return(
                body:   {
                  errors: [
                    {
                      name:    'access_token',
                      message: 'Incorrect email or password'
                    }
                  ]
                }.to_json,
                status: 400
              )
          end

          it '例外を投げる' do
            expect { subject }.to raise_error Api::Error
            expect(WebMock).to have_requested(:post, 'http://localhost:3000/api/token')
                                 .with(body: { email:, password: })
          end
        end

        context 'パスワードが正しい場合' do
          let(:password) { no_admin_user.password }

          before do
            WebMock
              .stub_request(:post, 'http://localhost:3000/api/token')
              .with(body: { email:, password: })
              .to_return(
                body:   {
                  errors: [
                    {
                      name:    'access_token',
                      message: 'You are not admin user'
                    }
                  ]
                }.to_json,
                status: 403
              )
          end

          it '例外を投げる' do
            expect { subject }.to raise_error Api::Error
            expect(WebMock).to have_requested(:post, 'http://localhost:3000/api/token')
                                 .with(body: { email:, password: })
          end
        end
      end
    end

    context '管理者ユーザの場合' do
      let(:admin_user) { create(:user, :admin) }

      context 'emailがない場合' do
        let(:email) { '' }
        let(:password) { admin_user.password }

        before do
          WebMock
            .stub_request(:post, 'http://localhost:3000/api/token')
            .with(body: { email:, password: })
            .to_return(
              body:   {
                errors: [
                  {
                    name:    'access_token',
                    message: 'Incorrect email or password'
                  }
                ]
              }.to_json,
              status: 400
            )
        end

        it '例外を投げる' do
          expect { subject }.to raise_error Api::Error
          expect(WebMock).to have_requested(:post, 'http://localhost:3000/api/token')
                               .with(body: { email:, password: })
        end
      end

      context 'emailがある場合' do
        let(:email) { admin_user.email }

        context 'パスワードが間違っている場合' do
          let(:password) { 'wrong_password' }

          before do
            WebMock
              .stub_request(:post, 'http://localhost:3000/api/token')
              .with(body: { email:, password: })
              .to_return(
                body:   {
                  errors: [
                    {
                      name:    'access_token',
                      message: 'Incorrect email or password'
                    }
                  ]
                }.to_json,
                status: 400
              )
          end

          it '例外を投げる' do
            expect { subject }.to raise_error Api::Error
            expect(WebMock).to have_requested(:post, 'http://localhost:3000/api/token')
                                 .with(body: { email:, password: })
          end
        end

        context 'emailとパスワードが正しい場合' do
          let(:password) { admin_user.password }

          before do
            WebMock
              .stub_request(:post, 'http://localhost:3000/api/token')
              .with(body: { email:, password: })
              .to_return(
                body:   {
                  access_token: AccessToken.new(email:).encode
                }.to_json,
                status: 200
              )
          end

          it 'アクセストークンが返る' do
            expect(subject.value).not_to be_nil
            expect(WebMock).to have_requested(:post, 'http://localhost:3000/api/token')
                                 .with(body: { email:, password: })
          end
        end
      end
    end
  end
end
