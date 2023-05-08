# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersEdit' do
  let!(:user) { create(:user) }
  let!(:other) { create(:user, :noadmin) }

  describe 'Get /users/{id}/edit' do
    #########################
    ## ログイン済み
    #########################
    context 'with login' do
      ## 入力情報が正しい
      context 'with valid info' do
        it 'scucess' do
          # フレンドリフォワーディング
          log_in_as(user)
          get edit_user_path(user)
          expect(response).to have_http_status :success

          name = 'Foo Bar'
          email = 'foo@bar.com'

          patch user_path(user), params: { user: { name:, email:, password: '', password_confirmation: '' } }

          expect(flash.empty?).not_to be true
          expect(response).to redirect_to user
          # expect(response).to have_http_status 302

          # リロードしてあってる確認
          user.reload
          expect(name).to eq user.name
          expect(email).to eq user.email
        end
      end

      ## 入力情報に不備
      context 'with invalid info' do
        ## 編集の失敗 422
        it 'unsuccessful edit' do
          log_in_as(user)
          get edit_user_path(user)
          expect(response).to have_http_status :success

          # 失敗するパッチ
          patch user_path(user),
                params: {
                  user: {
                    name:                  '',
                    email:                 'foo@invalid',
                    password:              'foo',
                    password_confirmation: 'bar'
                  }
                }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    #########################
    ## 別のユーザがログイン済み
    #########################
    context 'with other login' do
      before { log_in_as(other) }

      ## 別のユーザのページを見れてしまわないか検証する
      it 'does not allow to access other user' do
        get edit_user_path(user)
        expect(flash.empty?).to be true
        expect(response).to redirect_to root_url
      end

      it 'does not allow to edit other user' do
        patch user_path(user), params: { user: { name: user.name, email: user.email } }
        expect(flash.empty?).to be true
        expect(response).to redirect_to root_url
      end
    end

    #########################
    ## ログインなし
    #########################
    context 'without login' do
      it 'does not allow to show page' do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it 'does not allow to update' do
        patch user_path(user), params: { user: { name: user.name, email: user.email } }
        expect(flash.empty?).to be false
        expect(response).to redirect_to login_path
      end
    end
  end
end
