# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User' do
  describe '#get_list' do
    subject { Api::User.get_list(access_token:) }

    let(:user) { create(:user, :admin) }
    let(:access_token) { AccessToken.new(email: user.email).encode }

    it 'jsonのレスポンスを取得する' do
      expect { JSON.parse(subject) }.not_to raise_error(JSON::ParserError)
    end
  end
end
