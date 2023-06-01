# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApiUsers' do
  describe 'GET /api/users' do
    subject do
      get("/api/users?limit=#{limit}&offset=#{offset}", headers:)
      response
    end

    let(:limit) { 50 }
    let(:offset) { 1 }
    let!(:current_user) { create(:user, :admin) }
    let!(:user_list) { create_list(:user, limit, :noadmin) }

    context 'アクセストークンがない場合' do
      it 'エラーメッセージを出力して、404を返す' do
        expect(subject).to be_bad_request
        expect(subject.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがある場合' do
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }

        it 'エラーメッセージを出力して、401を返す' do
          expect(subject).to be_unauthorized
          expect(subject.parsed_body).to have_key('errors')
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        it 'ユーザ情報を取得し、200を返す' do
          expect(subject).to be_successful
          expect(subject.parsed_body.count).to eq limit
          response_ids = subject.parsed_body.pluck('id')
          expect(response_ids).to include user_list.first.id, user_list.last.id
          expect(response_ids).not_to include user_list.first.id - 1, user_list.last.id + 1
        end
      end
    end
  end

  describe 'GET /api/users/:id' do
    subject do
      get("/api/users/#{target_user.id}", headers:)
      response
    end

    let(:current_user) { create(:user, :admin) }
    let(:target_user) { create(:user, :noadmin) }

    context 'アクセストークンがない場合' do
      it '400でエラーメッセージを出力して失敗する' do
        expect(subject).to be_bad_request
        expect(subject.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがある場合' do
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }

        it '401でエラーメッセージを出力して失敗する' do
          expect(subject).to be_unauthorized
          expect(subject.parsed_body).to have_key('errors')
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        it 'ターゲットのIDのユーザ情報をレスポンスとして取得できる' do
          expect(subject).to be_successful
          expect(subject.parsed_body.symbolize_keys).to include(
            {
              id:           target_user.id,
              name:         target_user.name,
              admin:        target_user.admin,
              activated:    target_user.activated,
              activated_at: target_user.activated_at&.iso8601(2),
              created_at:   target_user.created_at.iso8601(2),
              updated_at:   target_user.updated_at.iso8601(2)
            }
          )
        end
      end
    end
  end

  describe 'POST /api/users' do
    subject { post '/api/users', headers:, params: }

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

    context 'アクセストークンがある場合' do
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }
      let!(:user) { create(:user, :admin) }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: user.email) }
        let(:params) do
          { name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password(min_length: 6) }
        end

        it '401でエラーメッセージを出力して失敗する' do
          expect { subject }.not_to change(User, :count)
          expect(response).to be_unauthorized
          expect(response.parsed_body).to have_key('errors')
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: user.email).encode }

        context 'パラメータが適切でない場合' do
          let(:name) { Faker::Name.name }
          let(:email) { Faker::Internet.email }
          let(:password) { Faker::Internet.password(min_length: 6) }
          let(:wrong_cases) do
            [
              { name: '', email:, password: },
              { name:, email: '', password: },
              { name:, email:, password: '' },
              * %w[
                user@example,com user_at_foo.org user.name@example. foo@bar_baz.com
                foo@bar+baz.com
              ].map do |wrong_email|
                { name:, email: wrong_email, password: }
              end,
              { name: 'a' * 51, email:, password: },
              {
                name:, email: "#{'a' * 244}@example.com", password:
              },
              { name:, email:, password: 'a' * 5 }
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

        context 'パラメータが適切な場合' do
          context 'ユーザが存在しない場合' do
            let(:params) do
              {
                name: Faker::Name.name, email: Faker::Internet.email,
                password: Faker::Internet.password(min_length: 6)
              }
            end

            it '201が返って、作成したユーザを返すこと' do
              expect { subject }.to change(User, :count).by(1)
              expect(response).to be_created
              expect(response.parsed_body).to include(
                *%w[id name admin activated activated_at created_at updated_at]
              )
            end
          end

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
        end
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    subject do
      delete("/api/users/#{target_id}", headers:)
      response
    end

    let!(:current_user) { create(:user, :admin) }
    let!(:target_user) { create(:user) }

    context 'アクセストークンがない場合' do
      let(:target_id) { current_user.id }

      it 'ユーザの削除に失敗し、エラーメッセージと400を返す' do
        expect(subject).to be_bad_request
        expect(subject.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがある場合' do
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }
        let(:target_id) { current_user.id }

        it 'ユーザの削除に失敗し、ユーザのエラーメッセージと401を返す' do
          expect(subject).to be_unauthorized
          expect(subject.parsed_body).to have_key('errors')
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        context '自分のユーザIDの場合' do
          let(:target_id) { current_user.id }

          it 'ユーザの削除に失敗し、エラーメッセージと422を返す' do
            expect(subject).to have_http_status :unprocessable_entity
            expect(subject.parsed_body).to have_key('errors')
          end
        end

        context '自分以外のユーザIDの場合' do
          context 'ユーザが存在しない場合' do
            let(:target_id) { 1_000_000 }

            it 'ユーザの削除に失敗し、エラーメッセージと404を返す' do
              expect(subject).to have_http_status :not_found
              expect(subject.parsed_body).to have_key('errors')
            end
          end

          context 'ユーザが存在する場合' do
            let(:target_id) { target_user.id }

            it 'ユーザが削除され、204を返す' do
              expect { subject }.to change(User, :count).by(-1)
              expect(subject).to have_http_status :no_content
            end
          end
        end
      end
    end
  end
end
