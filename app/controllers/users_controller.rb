# frozen_string_literal: true

# #paramsにUserのオブジェクトが渡るってことか
class UsersController < ApplicationController
  ## Userを作成するためのページを返すってこと
  ## つまりsingupにアクセスした時に呼ばれる => new.html.erb

  before_action :logged_in_user, only: %i[index edit update destroy following followers]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy

  def index
    # 有効なユーザだけ
    @users = User.where(activated: true).paginate(page: params[:page])
    # @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to(root_url, status: :see_other) and return unless @user.activated
    # debugger #差し込んでdebug止めたりできるっぽい
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  # /users/{id}のpostはcreateアクションに紐づいている
  def create
    ## logger.debug(user_params) とか使えばログ表示できて便利
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      # UserMailer.account_activation(@user).deliver_now
      flash[:info] = 'Please check email to activate your account'
      redirect_to root_url

      ################################################
      # アカウント有効化機能実装のためコメントアウト #
      ################################################
      # ##セッション固定攻撃対策
      # reset_session
      # log_in @user
      # # 保存が成功した時
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user # = redirect_to user_url(@user)
    else
      # :unprocessable_entity is 422 Unprocessable Entity
      # オブジェクトの変更に失敗した時であってう
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功
      # ユーザのページにリダイレクト
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url, status: :see_other
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end

  # strong parameterによる検証を行う必要がある

  private

  def user_params
    # パラメータの一部を除外
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    # unlessはif not
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url, status: :see_other
  end

  # 正しいユーザかどうか
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end
end
