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
end
