# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User' do
  describe '#get_list' do
    subject { Api::User.get_list(access_token:) }

    context 'アクセストークンがない場合' do
      let(:access_token) { nil }

      it 'errorsが返る' do
        expect(subject).to include Api::Error
      end
    end

    context 'アクセストークンがある場合' do
      let(:current_user) { create(:user, :admin) }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }

        it 'errorsが返る' do
          expect(subject).to include Api::Error
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        it 'ユーザの配列が返る' do
          expect(subject).to include Api::User
        end
      end
    end
  end

  describe '#create' do
    subject { Api::User.create(access_token:, name:, email:, password:, admin:) }

    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password(min_length: 6) }
    let(:admin) { [true, false].sample }

    context 'アクセストークンがない場合' do
      let(:access_token) { nil }

      it '例外が返る' do
        expect { subject }.to raise_error Api::Error
      end
    end

    context 'アクセストークンがある場合' do
      let(:current_user) { create(:user, :admin) }

      context 'アクセストークンが有効期限切れの場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }

        it '例外が返る' do
          expect { subject }.to raise_error Api::Error
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        it 'ユーザが返る' do
          expect(subject).to be_instance_of Api::User
        end
      end
    end
  end
end
