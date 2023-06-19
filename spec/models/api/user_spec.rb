# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User' do
  describe '#get_list' do
    subject { Api::User.get_list(access_token:) }

    context 'アクセストークンがない場合' do
      let(:access_token) { nil }

      pending 'errorsが返る' do
        expect(subject).to include Api::Error
      end
    end

    context 'アクセストークンがある場合' do
      let(:current_user) { create(:user, :admin) }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }

        pending 'errorsが返る' do
          expect(subject).to include Api::Error
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        pending 'ユーザの配列が返る' do
          expect(subject).to include Api::User
        end
      end
    end
  end
end
