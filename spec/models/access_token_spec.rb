# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessToken' do
  let(:email) { 'example@test.com' }
  let(:access_token) { AccessToken.new(email:).encode }
  let(:invalid_access_token) do
    issued_at = 11.hours.ago
    expired_at = issued_at + 1.hour
    payload = { sub: email, iat: issued_at.to_i, exp: expired_at.to_i }
    JWT.encode payload, Rails.application.credentials.app.secret_access_key, 'HS256'
  end

  describe '#from_token' do
    context 'トークンが正しい場合' do
      subject { AccessToken.from_token(access_token) }

      it 'デコードしてemailが読みとれる' do
        expect(subject.email).to eq email
      end
    end

    context 'トークンが期限切れの場合' do
      subject { AccessToken.from_token(invalid_access_token) }

      it 'デコードに失敗する' do
        expect(subject).to raise_error(JWT::ExpiredSignature, 'Signature has expired')
      end
    end
  end
end
