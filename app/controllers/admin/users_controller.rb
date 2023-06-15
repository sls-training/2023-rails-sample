# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_logged_in
    before_action :require_access_token

    # GET /admin/users
    def index
      # TODO: ユーザAPIを使ったものに後から置き換えること
      @users = User.limit(100)
    end

    private

    def require_logged_in
      return if logged_in?

      store_location
      redirect_to login_url, status: :see_other, flash: { danger: 'エラー : 管理者ユーザでログインしてください' }
    end

    def require_access_token
      return if verify_access_token?

      store_location
      redirect_to login_url, status: :see_other, flash: { danger: 'エラー : 管理者ユーザでログインしてください' }
    end
  end
end
