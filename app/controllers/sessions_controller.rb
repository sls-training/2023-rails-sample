class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password]) ## = user && user.authenticate(params[:session][:password])
      ################################################################
      ## ユーザーログイン後にユーザー情報のページにリダイレクトする ##
      ################################################################
      
      # セッション固定と呼ばれる攻撃に対応するためログインの前に書く
      # 対策 : ユーザがログインした直後にsessionをリセットすること
      # rails security guide
      reset_session
      
      ## ユーザページに遷移
      log_in user
      redirect_to user
    else
      ## flash -> flash.now : レンダリングが完了していても表示することができる
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end
  
  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
