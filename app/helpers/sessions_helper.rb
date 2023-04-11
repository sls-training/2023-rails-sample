module SessionsHelper
  def log_in(user)
    #sessionは一時cookiesとして自動的に暗号化される
    session[:user_id] = user.id
  end
  # 変数とかをメソッドで管理する感じ
  # c#のIsLoginプロパティが考え方的にしっくりくる
  def current_user
    if session[:user_id]
      # ユーザのメモ化 => reactのuseMemoですよ完全に理解した
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  #ログインしてるかどうか な
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    reset_session
    @current_user = nil
  end
end
