# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User' do
  describe '#get_list' do
    subject { Api::User.get_list(access_token:) }

    let(:user) { create(:user, :admin) }
    let(:access_token) { AccessToken.new(email: user.email).encode }

    it '配列のオブジェクトをレスポンスとして取得する' do
      expect(subject.instance_of?(Array)).to be true
    end
  end
end
