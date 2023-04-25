# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if account_active(user)
      activate(user)
      log_in user
      flash[:success] = 'Account activated!'
      redirect_to user

    # #トークンが無効になった場合
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end

  def account_active(user)
    user && !user.activated? && user.authenticated?(:activation, params[:id])
  end

  def activate(user)
    user.activate
    user.update_attribute(:activated, true)
    user.update_attribute(:activated_at, Time.zone.now)
  end
end
