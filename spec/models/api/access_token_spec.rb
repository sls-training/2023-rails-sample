# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessToken' do
  describe '#create' do
    subject { Api::AccessToken.create(email: user.email, password: user.password) }

    let(:user) { create(:user, :admin) }

    it '配列のオブジェクトをレスポンスとして取得する' do
      expect(subject.instance_of?(Array)).to be true
    end
  end
end
