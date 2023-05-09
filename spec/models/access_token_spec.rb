# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessToken' do
  let(:email) { 'example@test.com' }
  let(:access_token) { AccessToken.new(email:).encode }

  describe '#from_token' do
    subject { AccessToken.from_token(access_token) }

    context 'トークンが正しい場合' do
      it 'EmailがPayloadに入っている' do
        expect(subject.email).to eq email
      end
    end
  end
end
