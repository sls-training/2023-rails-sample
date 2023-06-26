# frozen_string_literal: true

module SessionsHelper
  EMAIL = Rails.application.credentials.app.rails_sample_email
  PASSWORD = Rails.application.credentials.app.rails_sample_password

  def log_in(user)
    # sessionは一時cookiesとして自動的に暗号化される
    session[:user_id] = user.id

    # セッションリプレイ攻撃からの保護
    # セッションCookieの値知ってたらずっとログインできちゃう追い出せない
    session[:session_token] = user.session_token
  end

  # 永続セッションのためにユーザをdbに記憶
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def verify_access_token?
    Api::AccessToken.new(value: access_token).valid?
  end

  def access_token
    cookies[:access_token]
  end

  # 変数とかをメソッドで管理する感じ
  # c#のIsLoginプロパティが考え方的にしっくりくる
  def current_user
    ## 永続セッションの場合、一時セッションからユーザを取り出す
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      current = user if user && session[:session_token] == user.session_token

      # # ユーザのメモ化 => reactのuseMemoですよ完全に理解した
      # @current_user ||= User.find_by(id: user_id)

      # それ以外？
      # sessionがない => loginしてないってこと
      # cookieから永続トークンが取れるならそこから一時セッションを復活させられる
      # これで永続トークンがexpireしない限り同じ端末でいつでもログイン状態になるのか
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in user
        current = user
      end
    end
    current
  end

  # ログインしてるかどうか な
  def logged_in?
    !current_user.nil?
  end

  # 永続セッションの破棄
  def forget(user)
    # モデル側に実装してある同じ関数呼び出すのよくあるよね確かに
    #
    # これがinterfaceとかでーだとBridgeパターンだった確か
    # railsでインターフェース使ったプリモーフィズムどうやるんだ？
    #
    # interfaceっぽいことやるなら
    # インターフェース相当のモジュールを用意して、それぞれのクラスでincludeするとからしい

    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    cookies.delete(:access_token)
    reset_session
  end

  ## こういうふうに関数化するのが慣習
  def current_user?(user)
    user && user == current_user
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
