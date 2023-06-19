# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def account_active(user)
    ################################################################
    ## ユーザーログイン後にユーザー情報のページにリダイレクトする ##
    ################################################################

    # フレンドリフォワーディング
    forwarding_url = session[:forwarding_url]

    # セッション固定と呼ばれる攻撃に対応するためログインの前に書く
    # 対策 : ユーザがログインした直後にsessionをリセットすること
    # rails security guide
    reset_session
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)

    ## ユーザページに遷移
    log_in user
    redirect_to forwarding_url || user
  end

  def account_not_acitve
    message = 'Account not activated. \nCheck your email for the activation link. '
    flash[:warning] = message
    redirect_to root_url
  end

  def account_not_authenticate
    ## flash -> flash.now : レンダリングが完了していても表示することができる
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new', status: :unprocessable_entity
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    @user = User.find_by(email:)
    if @user&.authenticate(password)
      if @user.activated?
        cookies.permanent[:access_token] = Api::AccessToken.create(email:, password:).value if @user.admin?
        account_active(@user)
      else
        account_not_acitve
      end
    else
      account_not_authenticate
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
