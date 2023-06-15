# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'User' do
  describe '#get_list' do
    subject { Api::User.get_list(access_token:) }

    before { WebMock.enable! }

    context 'アクセストークンがない場合' do
      let(:access_token) { nil }

      before do
        WebMock
          .stub_request(:post, 'http://localhost:3000/api/users')
          .with(
            query:   { limit: 50, offset: 0, order_by: 'asc', sort_by: 'name' },
            headers: { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{access_token}" }
          )
          .to_return(
            body:    {
              errors: [
                {
                  name:    'access_token',
                  message: 'Authentication token is missing'
                }
              ]
            },
            status:  400,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

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
end
