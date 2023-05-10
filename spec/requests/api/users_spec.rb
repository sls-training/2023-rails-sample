# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApiUsers' do
  describe 'GET /api/users/:id' do
    context 'アクセストークンが有効の場合' do
      let(:user) { create(:user, :admin) }
      let(:target) { create(:user, :noadmin) }
      let(:access_token) { AccessToken.new(email: user.email).encode }
      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Authorization' => "Bearer #{access_token}"
        }
      end

      it 'ターゲットのIDのユーザ情報をレスポンスとして取得できる' do
        get("/api/users/#{target.id}", headers:)
        expect(response).to be_successful
        user_data = JSON.parse(response.body, symbolize_names: true)
        target_data = {
          id:           target.id,
          name:         target.name,
          email:        target.email,
          admin:        target.admin,
          activated:    target.activated,
          activated_at: target.activated_at.iso8601(2),
          created_at:   target.created_at.iso8601(2),
          updated_at:   target.updated_at.iso8601(2)
        }
        expect(user_data).to eq target_data
      end
    end

    context 'アクセストークンが有効期限切れの場合' do
      let(:target) { create(:user, :noadmin) }
      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Authorization' => "Bearer #{expired_access_token}"
        }
      end

      it '401でエラーメッセージを出力して失敗する' do
        get("/api/users/#{target.id}", headers:)
        expect(response).to be_unauthorized
        expect(response.parsed_body).to have_key('message')
      end
    end

    context 'アクセストークンがない場合' do
      let(:target) { create(:user, :noadmin) }
      let(:headers) do
        {
          'Accept' => 'application/json'
        }
      end

      it '401でエラーメッセージを出力して失敗する' do
        get("/api/users/#{target.id}", headers:)
        expect(response).to be_unauthorized
        expect(response.parsed_body).to have_key('message')
      end
    end
  end
end
