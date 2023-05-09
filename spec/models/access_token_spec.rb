# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessToken' do
  describe '#encode' do
  end

  describe '#from_token' do
    it '生成したアクセストークンが正しくデコードできること' do
      email = 'uouo@uouo.com'
      access_token = AccessToken.new(email:).encode
      token = AccessToken.from_token(access_token)
      expect(token.email).to eq email
    end
  end
end
