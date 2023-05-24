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
      let(:email) { 'hogehoge@example.com' }
      let(:headers) { { 'Authorization' => "Bearer #{expired_access_token(email:)}" } }

      it 'ユーザの取得に失敗し、エラーメッセージと401を返して失敗する' do
        expect(subject).to be_unauthorized
        expect(subject.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがない場合' do
      it 'ユーザの取得に失敗し、エラーメッセージと400を返して失敗する' do
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
          let(:params) { { name: 'hogehgoe', email: user.email, password: 'foobar' } }

          it 'ユーザの作成に失敗し、エラーメッセージと422を返す' do
            expect { subject }.not_to change(User, :count)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.parsed_body).to have_key('errors')
          end
        end

        context 'ユーザが存在しない場合' do
          let(:params) { { name: 'hogehgoe', email: 'test@example.com', password: 'foobar' } }

          it 'ユーザの作成に成功し、作成したユーザの情報と201を返す' do
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
            { name: '', email: 'test@example.com', password: 'foobar' },
            { name: 'hogehgoe', email: '', password: 'foobar' },
            { name: 'hogehoge', email: 'test@example.com', password: '' },
            * %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com].map do |addr|
              { name: 'hogehgoe', email: addr, password: 'foobar' }
            end,
            { name: 'a' * 51, email: 'test@example.com', password: 'foobar'  },
            { name: 'hogehgoe', email: "#{'a' * 244}@example.com", password: 'foobar' },
            { name: 'hogehoge', email: 'test@example.com', password: 'a' * 5 }
          ]
        end

        it 'ユーザの削除に失敗し、エラーメッセージと400を返す' do
          wrong_cases.each do |wrong_case|
            expect { post '/api/users', headers:, params: wrong_case }.not_to change(User, :count)
            expect(response).to be_bad_request
            expect(response.parsed_body).to have_key('errors')
          end
        end
      end
    end

    context 'アクセストークンが有効期限切れの場合' do
      let(:email) { 'test@example.com' }
      let(:headers) { { 'Authorization' => "Bearer #{expired_access_token(email:)}" } }
      let(:params) { { name: 'hogehgoe', email: 'test@example.com', password: 'foobar' } }

      it 'ユーザの削除に失敗し、エラーメッセージと401を返す' do
        expect { subject }.not_to change(User, :count)
        expect(response).to be_unauthorized
        expect(response.parsed_body).to have_key('errors')
      end
    end

    context 'アクセストークンがない場合' do
      let(:params) { { name: 'hogehgoe', email: 'test@example.com', password: 'foobar' } }

      it 'ユーザの削除に失敗し、失敗するエラーメッセージと400を返す' do
        expect { subject }.not_to change(User, :count)
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to have_key('errors')
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

    context 'アクセストークンがある場合' do
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        context '自分以外のユーザIDの場合' do
          context 'ユーザが存在する場合' do
            let(:target_id) { target_user.id }

            it 'ユーザが削除され、204を返す' do
              expect { subject }.to change(User, :count).by(-1)
              expect(subject).to have_http_status :no_content
            end
          end

          context 'ユーザが存在しない場合' do
            let(:target_id) { 1_000_000 }

            it 'ユーザの削除に失敗し、エラーメッセージと404を返す' do
              expect(subject).to have_http_status :not_found
              expect(subject.parsed_body).to have_key('errors')
            end
          end
        end

        context '自分のユーザIDの場合' do
          let(:target_id) { current_user.id }

          it 'ユーザの削除に失敗し、エラーメッセージと422を返す' do
            expect(subject).to have_http_status :unprocessable_entity
            expect(subject.parsed_body).to have_key('errors')
          end
        end
      end

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }
        let(:target_id) { current_user.id }

        it 'ユーザの削除に失敗し、ユーザのエラーメッセージと401を返す' do
          expect(subject).to be_unauthorized
          expect(subject.parsed_body).to have_key('errors')
        end
      end
    end

    context 'アクセストークンがない場合' do
      let(:target_id) { current_user.id }

      it 'ユーザの削除に失敗し、エラーメッセージと400を返す' do
        expect(subject).to be_bad_request
        expect(subject.parsed_body).to have_key('errors')
      end
    end
  end
end
