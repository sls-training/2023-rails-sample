require 'rails_helper'

RSpec.describe 'Login', type: :request do
  let(:user) { FactoryBot.create(:user) }

  include SessionsSupport
  describe 'GET /login' do
    it 'is correct routing' do
      get login_path
      expect(response).to have_http_status(:ok)
    end

    ## 成功する場合
    context 'with valid info' do
      before { post login_path, params: { session: { email: user.email, password: 'password' } } }

      # ログインの許可
      it 'allows to login' do
        log_in_as(user)
        expect(is_logged_in?).to be_truthy
        expect(response).to redirect_to user_path(user)
      end

      # ログインした後のリダイレクト先があっているか
      it 'redirects after login' do
        follow_redirect!
        assert_select 'a[href=?]', login_path, count: 0
        assert_select 'a[href=?]', logout_path
        assert_select 'a[href=?]', user_path(user)
      end
    end

    # 失敗する場合
    context 'with invalid info' do
      before { post login_path, params: { session: { email: user.email, password: 'invalid' } } }

      it 'does not allow to login with valid email/invalid password' do
        expect(is_logged_in?).not_to be_truthy
      end
    end
  end

  describe 'remembering' do
    it 'checks remembering' do
      log_in_as(user, remember_me: '1')
      expect(cookies[:remember_token].blank?).to be_falsey
    end

    it 'does not check remembering' do
      log_in_as(user, remember_me: '1')
      log_in_as(user, remember_me: '0')
      expect(cookies[:remember_token].blank?).to be_truthy
    end
  end
end
