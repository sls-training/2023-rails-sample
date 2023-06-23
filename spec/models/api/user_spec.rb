# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User' do
  describe '#get_list' do
    subject { Api::User.get_list(access_token:) }

    let(:limit) { 50 }
    let(:sort_key) { 'name' }
    let(:order_by) { 'asc' }
    let(:offset) { 0 }
    let(:current_user) { create(:user, :admin) }

    context 'APIサーバーにアクセスできない場合' do
      let(:access_token) { AccessToken.new(email: current_user.email).encode }

      before do
        WebMock
          .stub_request(:get, 'http://localhost:3000/api/users')
          .with(
            query:   { limit:, offset:, order_by:, sort_key: },
            headers: { Authorization: "Bearer #{access_token}" }
          )
          .to_raise(StandardError)
      end

      it 'ユーザ取得のAPIを呼ぶことに失敗し、例外を返す' do
        expect { subject }.to raise_error StandardError
        expect(WebMock).to have_requested(:get, 'http://localhost:3000/api/users')
                             .with(
                               query:   { limit:, offset:, order_by:, sort_key: },
                               headers: { Authorization: "Bearer #{access_token}" }
                             )
      end
    end

    context 'APIサーバーにアクセスできる場合' do
      context '不正なクエリパラメータ、アクセストークンが指定された場合' do
        let(:access_token) { expired_access_token(email: current_user.email) }

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

        it 'ユーザ取得のAPIを呼び、例外を返す' do
          expect { subject }.to raise_error Api::Error
          expect(WebMock).to have_requested(:get, 'http://localhost:3000/api/users')
                               .with(
                                 query:   { limit:, offset:, order_by:, sort_key: },
                                 headers: { Authorization: "Bearer #{access_token}" }
                               )
        end
      end

      context '正当なクエリパラメータ、アクセストークンが指定された場合' do
        before do
          WebMock
            .stub_request(:get, 'http://localhost:3000/api/users')
            .with(
              query:   { limit:, offset:, order_by:, sort_key: },
              headers: { Authorization: "Bearer #{access_token}" }
            )
            .to_return(
              body:    User
                       .order(sort_key => order_by)
                       .limit(limit)
                       .offset(offset).map { |user| user_to_api_user(user) }
                       .to_json,
              status:  200,
              headers: { 'Content-Type' => 'application/json' }
            )
        end

        let(:access_token) { AccessToken.new(email: current_user.email).encode }

        it 'ユーザ取得のAPIを呼び、ユーザの配列を返す' do
          expect(subject).to include Api::User
          expect(WebMock).to have_requested(:get, 'http://localhost:3000/api/users')
                               .with(
                                 query:   { limit:, offset:, order_by:, sort_key: },
                                 headers: { Authorization: "Bearer #{access_token}" }
                               )
        end
      end
    end
  end
end
