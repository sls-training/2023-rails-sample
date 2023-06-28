# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApiTokens' do
  describe 'POST /api/token' do
    include Committee::Rails::Test::Methods

    context 'ユーザが存在する場合' do
      context 'ユーザがadminの場合' do
        let(:user) { create(:user, :admin) }
        let(:headers) { { 'Content-Type': 'application/json' } }

        it '200が返って、アクセストークンを返すこと' do
          post '/api/token', headers:, params: { email: user.email, password: user.password }, as: :json
          assert_response_schema_confirm(200)
        end
      end

      context 'ユーザがAdminでない場合' do
        let(:noadmin) { create(:user, :noadmin) }

        it '403が返って、エラーメッセージを返すこと' do
          post '/api/token', headers:, params: { email: noadmin.email, password: noadmin.password }, as: :json
          assert_response_schema_confirm(403)
        end
      end
    end

    context 'ユーザが存在しない場合' do
      it '401が返って、エラーメッセージを返すこと' do
        post '/api/token', headers:, params: { email: 'test@hogehgoe.com', password: 'invalid password' }, as: :json
        assert_response_schema_confirm(401)
      end
    end
  end
end
