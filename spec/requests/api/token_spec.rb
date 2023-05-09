# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApiToken' do
  let(:user) { create(:user) }
  let(:noadmin) { create(:user, :noadmin) }

  # Token生成のAPIのテスト

  describe 'POST /api/token' do
    context 'ユーザが存在する場合' do
      context 'ユーザがadminの場合' do
        it '200が返って、アクセストークンを返すこと' do
          post '/api/token', params: { email: user.email, password: user.password }
          expect(response).to be_successful
          expect(response.parsed_body).to have_key('access_token')
        end
      end

      context 'ユーザがAdminでない場合' do
        it '403が返って、エラーメッセージを返すこと' do
          post '/api/token', params: { email: noadmin.email, password: noadmin.password }
          expect(response).to have_http_status :forbidden
          expect(response.body.parsed_body).to have_key(:message)
        end
      end
    end

    context 'ユーザが存在しない場合' do
      it '401が返って、エラーメッセージを返すこと' do
        post '/api/token', params: { email: 'test@hogehgoe.com', password: 'invalid password' }
        expect(response).to have_http_status :unauthorized
        expect(response.body.parsed_body).to have_key(:message)
      end
    end
  end
end
