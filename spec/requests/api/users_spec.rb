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
      let(:headers) do
        {
          'Authorization' => "Bearer #{access_token}"
        }
      end

      it 'ターゲットのIDのユーザ情報をレスポンスとして取得できる' do
        expect(subject).to be_successful

        user_data = JSON.parse(subject.body, symbolize_names: true)
        expect(user_data).to include(
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
      let(:headers) do
        {
          'Authorization' => "Bearer #{expired_access_token}"
        }
      end

      it '401でエラーメッセージを出力して失敗する' do
        expect(subject).to be_unauthorized
        expect(subject.parsed_body).to have_key('message')
      end
    end

    context 'アクセストークンがない場合' do
      it '401でエラーメッセージを出力して失敗する' do
        get("/api/users/#{target.id}")
        expect(subject).to be_unauthorized
        expect(subject.parsed_body).to have_key('message')
      end
    end
  end
end
