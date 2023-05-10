# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessToken' do
  describe '#from_token' do
    context 'アクセストークンが正しい場合' do
      subject { AccessToken.from_token(access_token) }

      let(:email) { 'example@test.com' }
      let(:access_token) { AccessToken.new(email:).encode }

      it 'デコードしてemailが読みとれる' do
        expect(subject.email).to eq email
      end
    end

    context 'アクセストークンが期限切れの場合' do
      subject { AccessToken.from_token(expired_access_token) }

      let(:expired_access_token) do
        issued_at = 11.hours.ago
        expired_at = issued_at + 1.hour
        payload = { sub: email, iat: issued_at.to_i, exp: expired_at.to_i }
        JWT.encode payload, Rails.application.credentials.app.secret_access_key, 'HS256'
      end

      it 'アクセストークンのデコードに失敗する' do
        expect { subject }.to raise_error(JWT::ExpiredSignature, 'Signature has expired')
      end
    end
  end

  describe '#encode' do
    let(:email) { 'example@test.com' }
    let(:access_token) { AccessToken.new(email:).encode }
    let(:header) { JSON.parse(Base64.decode64(access_token.split('.')[0]), symbolize_names: true) }
    let(:payload) { JSON.parse(Base64.decode64(access_token.split('.')[1]), symbolize_names: true) }

    it 'アルゴリズムにHS256が設定してある' do
      expect(header[:alg]).to eq 'HS256'
    end

    it 'subにemailが設定されている' do
      expect(payload[:sub]).to eq email
    end

    it '有効期限が1時間である' do
      expect(payload[:exp] - payload[:iat]).to eq 1.hour.to_i
    end
  end
end
