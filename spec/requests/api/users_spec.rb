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
            activated_at: target.activated_at&.iso8601(2),
            created_at:   target.created_at.iso8601(2),
            updated_at:   target.updated_at.iso8601(2)
          }
        )
      end
    end

    context 'アクセストークンが有効期限切れの場合' do
      let(:headers) { { 'Authorization' => "Bearer #{expired_access_token(email: Faker::Internet.email)}" } }

      it '401でエラーメッセージを出力して失敗する' do
        expect(subject).to be_unauthorized
        expect(subject.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがない場合' do
      it '400でエラーメッセージを出力して失敗する' do
        expect(subject).to be_bad_request
        expect(subject.parsed_body).to have_key('errors')
      end
    end
  end

  describe 'POST /api/users' do
    subject { post '/api/users', headers:, params: }

    context 'アクセストークンが有効の場合' do
      let!(:user) { create(:user, :admin) }
      let(:access_token) { AccessToken.new(email: user.email).encode }
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      context 'パラメータが適切な場合' do
        context 'ユーザが存在する場合' do
          let(:params) do
            { name: Faker::Name.name, email: user.email, password: Faker::Internet.password(min_length: 6) }
          end

          it '422が返って、エラーメッセージを返すこと' do
            expect { subject }.not_to change(User, :count)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.parsed_body).to have_key('errors')
          end
        end

        context 'ユーザが存在しない場合' do
          let(:params) do
            { name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password(min_length: 6) }
          end

          it '201が返って、作成したユーザを返すこと' do
            expect { subject }.to change(User, :count).by(1)
            expect(response).to be_created
            expect(response.parsed_body).to include(
              *%w[id name admin activated activated_at created_at updated_at]
            )
          end
        end
      end

      context 'パラメータが適切でない場合' do
        let(:wrong_cases) do
          [
            { name: '', email: Faker::Internet.email, password: Faker::Internet.password(min_length: 6) },
            { name: Faker::Name.name, email: '', password: Faker::Internet.password(min_length: 6) },
            { name: Faker::Name.name, email: Faker::Internet.email, password: '' },
            * %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com].map do |addr|
              { name: Faker::Name.name, email: addr, password: Faker::Internet.password(min_length: 6) }
            end,
            { name: 'a' * 51, email: Faker::Internet.email, password: Faker::Internet.password(min_length: 6) },
            {
              name: Faker::Name.name, email: "#{'a' * 244}@example.com",
password: Faker::Internet.password(min_length: 6)
            },
            { name: Faker::Name.name, email: Faker::Internet.email, password: 'a' * 5 }
          ]
        end

        it '400が返って、エラーメッセージを返すこと' do
          wrong_cases.each do |wrong_case|
            expect { post '/api/users', headers:, params: wrong_case }.not_to change(User, :count)
            expect(response).to be_bad_request
            expect(response.parsed_body).to have_key('errors')
          end
        end
      end
    end

    context 'アクセストークンが有効期限切れの場合' do
      let(:email) { Faker::Internet.email }
      let(:headers) { { 'Authorization' => "Bearer #{expired_access_token(email:)}" } }
      let(:params) do
        { name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password(min_length: 6) }
      end

      it '401でエラーメッセージを出力して失敗する' do
        expect { subject }.not_to change(User, :count)
        expect(response).to be_unauthorized
        expect(response.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがない場合' do
      let(:params) do
        { name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password(min_length: 6) }
      end

      it '400でエラーメッセージを出力して失敗する' do
        expect { subject }.not_to change(User, :count)
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to have_key('errors')
      end
    end
  end
end
