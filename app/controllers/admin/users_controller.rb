# frozen_string_literal: true

require 'net/https'
require 'uri'

module Admin
  class UsersController < ApplicationController
    before_action :require_admin_user
    def index; end

    def require_admin_user
      return if logged_in? && current_user.admin?

      store_location
      redirect_to login_url, status: :see_other, flash: { danger: 'エラー : 管理者ユーザでログインしてください' }
    end
  end
end
