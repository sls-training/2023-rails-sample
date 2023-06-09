# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessToken' do
  let(:email) { 'example@test.com' }

  describe '#from_token' do
    context 'アクセストークンが正しい場合' do
      subject { AccessToken.from_token(access_token) }

      let(:access_token) { AccessToken.new(email:).encode }

      it 'デコードしてemailが読みとれる' do
        expect(subject.email).to eq email
      end
    end

    context 'アクセストークンが期限切れの場合' do
      subject { AccessToken.from_token(expired_access_token(email:)) }

      it 'アクセストークンのデコードに失敗する' do
        expect { subject }.to raise_error(JWT::ExpiredSignature, 'Signature has expired')
      end
    end
  end

  describe '#encode' do
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
