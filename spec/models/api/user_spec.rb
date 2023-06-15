# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'User' do
  describe '#get_list' do
    subject { Api::User.get_list(access_token:) }

    before { WebMock.enable! }

    let(:limit) { 50 }
    let(:sort_key) { 'name' }
    let(:order_by) { 'asc' }
    let(:offset) { 0 }

    context 'アクセストークンがない場合' do
      let(:access_token) { nil }

      before do
        WebMock
          .stub_request(:get, 'http://localhost:3000/api/users')
          .with(query: { limit:, offset:, order_by:, sort_key: })
          .to_return(
            body:    {
              errors: [
                {
                  name:    'access_token',
                  message: 'Authentication token is missing'
                }
              ]
            }.to_json,
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
        before do
          WebMock
            .stub_request(:get, 'http://localhost:3000/api/users')
            .with(
              query:   { limit:, offset:, order_by:, sort_key: },
              headers: { Authorization: "Bearer #{access_token}" }
            )
            .to_return(
              body:   {
                errors: [
                  {
                    name:    'access_token',
                    message: 'Invalid token'
                  }
                ]
              }.to_json,
              status: 401
            )
        end

        let(:access_token) { expired_access_token(email: current_user.email) }

        it 'errorsが返る' do
          expect(subject).to include Api::Error
        end
      end

      context 'アクセストークンが有効期限内の場合' do
        before do
          def users_to_json(users)
            users.map do |user|
              {
                id:           user.id,
                name:         user.name,
                email:        user.email,
                admin:        user.admin,
                activated:    user.activated,
                activated_at: user.activated_at&.iso8601(2),
                created_at:   user.created_at.iso8601(2),
                updated_at:   user.updated_at.iso8601(2)
              }
            end.to_json
          end
          WebMock
            .stub_request(:get, 'http://localhost:3000/api/users')
            .with(
              query:   { limit:, offset:, order_by:, sort_key: },
              headers: { Authorization: "Bearer #{access_token}" }
            )
            .to_return(
              body:    users_to_json(
                User
                  .order(sort_key => order_by)
                  .limit(limit)
                  .offset(offset)
              ),
              status:  200,
              headers: { 'Content-Type' => 'application/json' }
            )
        end

        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        it 'ユーザの配列が返る' do
          expect(subject).to include Api::User
        end
      end
    end
  end
end
