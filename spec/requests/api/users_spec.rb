# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApiUsers' do
  describe 'GET /api/users/:id' do
    subject do
      get("/api/users/#{target.id}", headers:)
      response
    end

    let(:target) { create(:user, :noadmin) }

    context 'アクセストークンが有効の場合' do
      let(:user) { create(:user, :admin) }
      let(:access_token) { AccessToken.new(email: user.email).encode }
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      it 'ターゲットのIDのユーザ情報をレスポンスとして取得できる' do
        expect(subject).to be_successful
        expect(subject.parsed_body.symbolize_keys).to include(
          {
            id:           target.id,
            name:         target.name,
            admin:        target.admin,
            activated:    target.activated,
            activated_at: target.activated_at.iso8601(2),
            created_at:   target.created_at.iso8601(2),
            updated_at:   target.updated_at.iso8601(2)
          }
        )
      end
    end

    context 'アクセストークンが有効期限切れの場合' do
      let(:email) { 'hogehoge@example.com' }
      let(:headers) { { 'Authorization' => "Bearer #{expired_access_token(email:)}" } }

      it '401でエラーメッセージを出力して失敗する' do
        expect(subject).to be_unauthorized
        expect(subject.parsed_body).to have_key('message')
      end
    end

    context 'アクセストークンがない場合' do
      it '400でエラーメッセージを出力して失敗する' do
        expect(subject).to be_bad_request
        expect(subject.parsed_body).to have_key('message')
      end
    end
  end

  describe 'POST /api/users' do
    subject do
      post '/api/users', headers:, params: { name:, email:, password: }
      response
    end

    let(:name) { 'hogehgoe' }
    let(:email) { 'hoge@example.com' }
    let(:password) { 'foobar' }

    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'アクセストークンが有効の場合' do
      let!(:user) { create(:user, :admin) }
      let(:access_token) { AccessToken.new(email: user.email).encode }
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      context 'パラメータが適切な場合' do
        context 'ユーザが存在する場合' do
          let(:email) { user.email }

          it '422が返って、エラーメッセージを返すこと' do
            expect(subject).to have_http_status(:unprocessable_entity)
            expect(subject).to have_error 'email', 'has already been taken'
            expect { subject }.not_to change(User, :count)
          end
        end

        context 'ユーザが存在しない場合' do
          it '201が返って、作成したユーザを返すこと' do
            expect(subject).to be_created
            expect(subject.parsed_body.symbolize_keys).to include(
              :id,
              :name,
              :admin,
              :activated,
              :activated_at,
              :created_at,
              :updated_at
            )
            expect { subject }.to change(User, :count).by(1)
          end
        end
      end

      context '名前がない場合' do
        let(:name) { '' }

        it '400が返って、エラーメッセージを返すこと' do
          expect(subject).to be_bad_request
          expect(subject).to have_error 'name', "can't be blank"
        end
      end

      context 'メールがない場合' do
        let(:email) { '' }

        it '400が返って、エラーメッセージを返すこと' do
          expect(subject).to be_bad_request
          expect(subject).to have_error 'email', 'is invalid'
        end
      end

      context 'パスワードがない場合' do
        let(:password) { '' }

        it '400が返って、エラーメッセージを返すこと' do
          expect(subject).to be_bad_request
          expect(subject).to have_error 'password', "can't be blank"
        end
      end

      context 'メールの形式が間違っている場合' do
        let(:email) { 'invalid@email' }

        it '400が返って、エラーメッセージを返すこと' do
          invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
          invalid_addresses.each do |_invalid_address|
            expect(subject).to be_bad_request
            expect(subject).to have_error 'email', 'is invalid'
          end
        end
      end

      context '名前が長すぎる場合' do
        let(:name) { 'a' * 51 }

        it '400が返って、エラーメッセージを返すこと' do
          expect(subject).to be_bad_request
          expect(subject).to have_error 'name', 'is too long (maximum is 50 characters)'
        end
      end

      context 'メールが長すぎる場合' do
        let(:email) { "#{'a' * 244}@example.com" }

        it '400が返って、エラーメッセージを返すこと' do
          expect(subject).to be_bad_request
          expect(subject).to have_error 'email', 'is too long (maximum is 255 characters)'
        end
      end

      context 'パスワードが短すぎる場合' do
        let(:password) { 'a' * 5 }

        it '400が返って、エラーメッセージを返すこと' do
          expect(subject).to be_bad_request
          expect(subject).to have_error 'password', 'is too short (minimum is 6 characters)'
        end
      end
    end

    context 'アクセストークンが有効期限切れの場合' do
      let(:headers) { { 'Authorization' => "Bearer #{expired_access_token(email:)}" } }

      it '401でエラーメッセージを出力して失敗する' do
        expect(subject).to be_unauthorized
        expect(subject.parsed_body).to have_key('message')
      end
    end

    context 'アクセストークンがない場合' do
      it '400でエラーメッセージを出力して失敗する' do
        expect(subject).to be_bad_request
        expect(subject.parsed_body).to have_key('message')
      end
    end
  end
end
