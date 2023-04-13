require "test_helper"


class UsersSignup < ActionDispatch::IntegrationTest
  def setup
    # deliveresはグローバルな配列なので初期化しておく
    # メール配信用のテスト同士が干渉するのを防ぐ
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup
  ## User作成に失敗するときのテスト
  test "invalid signup information" do
    get signup_path

    ## postする前後でUser.countに変化がないことを検証する
    ## invalidなuserが作られていないか検証できる
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                          email: "user@invalid",
                                          password: "foo", 
                                          password_confirmation: "bar"}}
      end
      # 422 Unprocessable Entity
      # サーバー側で構文等は理解できてるけど処理できない場合
      assert_response :unprocessable_entity
      assert_template 'users/new'
      # assert_select "div.nav"	 ### 例えばこういうのがあるか検証できる「<div class="nav">foobar</div>」
    end
    
      ## User作成に成功するときのテスト
  test "valid signup information with account activation" do
    get signup_path

    ## postする前後でUser.countに変化がないことを検証する
    ## invalidなuserが作られていないか検証できる
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Uouo Example",
                                          email: "uouo@example.com",
                                          password: "hogehoge", 
                                          password_confirmation: "hogehoge"}}
      end
    
      assert_equal 1, ActionMailer::Base.deliveries.size
    
      #follow_redirect! ## follow_redirectはメソッド、!がついてるから失敗すると例外で失敗する
      # assert_template 'users/show'
      # # assert_select "div.nav"	 ### 例えばこういうのがあるか検証できる「<div class="nav">foobar</div>」
      # assert is_logged_in?
    end
end


class AccountActivationTest < UsersSignup
  def setup
    super
    post users_path, params: { user: { name:  "Example User",
                                       email: "user@example.com",
                                       password:              "password",
                                       password_confirmation: "password" } }
    # assignsはテスト用の関数
    # 5から非推奨
    # インスタンス変数に簡単にアクセスできる
    @user = assigns(:user)
  end
  
  # こっからコピペ
  test "should not be activated" do
    assert_not @user.activated?
  end

  # アカウントがアクティブになる前にログインできたりしないよね？
  test "should not be able to log in before account activation" do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid activation token" do
    get edit_account_activation_path("invalid token", email: @user.email)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid email" do
    get edit_account_activation_path(@user.activation_token, email: 'wrong')
    assert_not is_logged_in?
  end

  test "should log in successfully with valid activation token and email" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
