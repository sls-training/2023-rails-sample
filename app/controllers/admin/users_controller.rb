# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_admin_user

    # GET /admin/users
    def index
      # TODO: ユーザAPIを使ったものに後から置き換えること
      @users = User.limit(100)
    end

    def create
      # TODO: ユーザ作成のAPIを呼ぶ
    end

    private

    def require_admin_user
      return if logged_in? && current_user.admin?

      store_location
      redirect_to login_url, status: :see_other, flash: { danger: 'エラー : 管理者ユーザでログインしてください' }
    end
  end
end
