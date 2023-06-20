# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'AdminUsers' do
  let!(:admin_user) { create(:user, :admin) }
  let!(:non_admin_user) { create(:user, :noadmin) }

  describe 'GET /admin/users' do
    subject { get admin_users_path }

    context 'ユーザが管理者の場合' do
      before do
        # テスト用のユーザを事前に作成
        create_list(:user, 50)
        access_token = AccessToken.new(email:).encode

        # トークン作成用のAPI
        WebMock
          .stub_request(:post, 'http://localhost:3000/api/token')
          .with(body: { email:, password: })
          .to_return(body: { access_token: }.to_json, status: 200, headers: { 'Content-Type' => 'application/json' })

        # ログインする
        post login_path,
             params: { session: { email:, password:, remember_me: '1' } }
      end

      let(:email) { admin_user.email }

      context 'パスワードがあっている場合' do
        let(:password) { admin_user.password }

        before do
          limit = 10
          sort_key = 'name'
          order_by = 'asc'
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
                       .offset(offset)
                       .map { |user| user_to_api_user(user) }
                       .to_json,
              status:  200,
              headers: { 'Content-Type' => 'application/json' }
            )
        end

        context 'pageが0の場合' do
          let(:page) { 0 }
          let(:offset) { 0 }

          it 'offsetが0で200が返る' do
            subject
            expect(response).to be_successful
          end

          it 'ユーザの表示数は10' do
            subject
            @user = controller.instance_variable_get(:@user)
            expect(@user.count).to eq 10
          end
        end

        context 'pageが1の場合' do
          let(:page) { 1 }
          let(:offset) { 0 }

          it 'offsetが0で200が返る' do
            subject
            expect(response).to be_successful
          end

          it 'ユーザの表示数は10' do
            subject
            @user = controller.instance_variable_get(:@user)
            expect(@user.count).to eq 10
          end
        end

        context 'pageが2の場合' do
          let(:page) { 2 }
          let(:offset) { 10 }

          it 'offsetが10で200が返る' do
            subject
            expect(response).to be_successful
          end

          it 'ユーザの表示数は10' do
            subject
            @user = controller.instance_variable_get(:@user)
            expect(@user.count).to eq 10
          end
        end
      end

      context 'パスワードを間違えた場合' do
        let(:page) { 0 }
        let(:password) { 'wrong_password' }

        it 'ログインページにリダイレクトしてトーストメッセージを表示' do
          expect(subject).to redirect_to login_url
          expect(response).to have_http_status :see_other
          expect(flash[:danger]).not_to be_nil
        end
      end
    end

    context 'ユーザが管理者ではない場合' do
      let(:page) { 0 }
      let(:email) { non_admin_user.email }
      let(:password) { non_admin_user.password }

      it 'ログインページにリダイレクトしてトーストメッセージを表示' do
        expect(subject).to redirect_to login_url
        expect(response).to have_http_status :see_other
        expect(flash[:danger]).not_to be_nil
      end
    end
  end
end
