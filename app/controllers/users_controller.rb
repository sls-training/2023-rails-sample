##paramsにUserのオブジェクトが渡るってことか
class UsersController < ApplicationController
  ## Userを作成するためのページを返すってこと
  ## つまりsingupにアクセスした時に呼ばれる => new.html.erb
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    #debugger #差し込んでdebug止めたりできるっぽい
  end

  #/users/{id}のpostはcreateアクションに紐づいている
  def create
    ## logger.debug(user_params) とか使えばログ表示できて便利
    @user = User.new(user_params)
    if @user.save
      # 保存が成功した時
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # = redirect_to user_url(@user)
    else
      # :unprocessable_entity is 422 Unprocessable Entity
      render 'new', status: :unprocessable_entity
    end
  end

  # strong parameterによる検証を行う必要がある  
  private
    def user_params
      # パラメータの一部を除外
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
