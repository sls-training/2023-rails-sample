# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def edit; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Eamil sent with password reset instruction'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "Can't be empty")
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params)
      # パスワードを変えた時にユーザのsessionを初期化
      # @user.forget
      reset_session

      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = 'Password has been reset. '
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    redirect_to root_url unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
  end

  # トークンが期限切れかどうかを確認する
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset has expired'
    redirect_to new_password_reset_url
  end
end
