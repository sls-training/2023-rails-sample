# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApiV1Token' do
  let(:user) { create(:user) }

  # Token生成のAPIのテスト
  describe 'POST /api/v1/token' do
    it '正しいログイン情報の場合' do
      post '/api/v1/token', params: { email: user.email, password: user.password }
      expect(response).to be_successful
      expect(response.parsed_body.keys).to include('token_type', 'access_token')
    end

    it '不明なログイン情報の場合' do
      post '/api/v1/token', params: { email: 'test@hogehgoe.com', password: 'invalid password' }
      expect(response).to have_http_status :unauthorized
      expect(response.body).to include 'message'
    end
  end
end
