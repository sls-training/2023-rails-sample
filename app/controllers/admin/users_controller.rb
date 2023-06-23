# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_logged_in
    before_action :require_access_token
    DISPLAY_AMOUNT = 10 # 表示数
    # GET /admin/users
    def index
      # TODO: ユーザのcountをAPIから取得できるようにすること
      user_count = User.count
      begin
        user_list = Api::User.get_list(
          access_token:,
          limit:        DISPLAY_AMOUNT,
          offset:       DISPLAY_AMOUNT * [(params[:page].to_i - 1), 0].max
        )
      rescue StandardError => e
        redirect_to root_url, status: :see_other, flash: { danger: e } and return
      end
      total_count = (user_count / DISPLAY_AMOUNT) * DISPLAY_AMOUNT
      @users = Kaminari.paginate_array(user_list, total_count:).page(params[:page]).per(DISPLAY_AMOUNT)
    end

    def create
      # TODO: ユーザ作成のAPIを呼ぶ
    end

    def update
      # TODO: ユーザ編集するAPIを叩く
    end

    def destroy
      # TODO: ユーザ削除のAPIを呼ぶ
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
