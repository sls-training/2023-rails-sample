require 'rails_helper'

RSpec.describe 'UsersSignup' do
  before { ActionMailer::Base.deliveries.clear }

  #################################################
  ## contextの書き方としては、〇〇な場合を連ねていくのが
  ## 正しそう、つまりこの書き方 is ヤバイ
  #############################################
  describe 'Signup test' do
    it 'is invalid' do
      ## postする前後でUser.countに変化がないことを検証する
      ## invalidなuserが作られていないか検証できる
      get signup_path
      expect do
        post users_path,
             params: {
               user: {
                 name: '',
                 email: 'user@invalid',
                 password: 'foo',
                 password_confirmation: 'bar'
               }
             }
      end.not_to change(User, :count)

      # have_http_statusっていうマッチャってこと？
      # RSpec::Rails::Matchersらしい、
      expect(response).to have_http_status :unprocessable_entity
      # #.  チュートリアルではこんなの書いてあったけど
      # #.  これ検証するのUIのテスト作るってのが正しそう
      ##   assert_template 'users/new'
    end

    it 'is valid sign up information with account activation' do
      get signup_path

      expect do
        post users_path,
             params: {
               user: {
                 name: 'Uouo Example',
                 email: 'uouo@example.com',
                 password: 'hogehoge',
                 password_confirmation: 'hogehoge'
               }
             }
      end.to change(User, :count)

      expect(ActionMailer::Base.deliveries.size).to eq 1
    end
  end

  describe 'Account activation test' do
    before do
      post users_path,
           params: {
             user: {
               name: 'Example User',
               email: 'user@example.com',
               password: 'password',
               password_confirmation: 'password'
             }
           }
      @user = controller.instance_variable_get('@user')
    end
    # let(:user) = FactoryBot.create()

    context 'with no activation' do
      it 'is no activation user' do
        expect(@user.activated?).not_to be_truthy
      end

      # アカウントがアクティブになる前にログインできたりしないよね？
      it 'does not allow login before account activation' do
        log_in_as(@user)
        expect(is_logged_in?).not_to be_truthy
      end

      it 'does not allow login with invalid activation token' do
        get edit_account_activation_path('invalid token', email: @user.email)
        expect(is_logged_in?).not_to be_truthy
      end

      it 'does not allow login with invalid email' do
        get edit_account_activation_path(@user.activation_token, email: 'wrong')
        expect(is_logged_in?).not_to be_truthy
      end
    end

    context 'with activation' do
      it 'allows valid activation token and email' do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(@user.reload.activated?).to be_truthy
        follow_redirect!
        expect(is_logged_in?).to be_truthy
      end
    end
  end
end
