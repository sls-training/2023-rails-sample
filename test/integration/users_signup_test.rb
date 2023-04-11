require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
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
  test "valid signup information" do
    get signup_path

    ## postする前後でUser.countに変化がないことを検証する
    ## invalidなuserが作られていないか検証できる
    assert_difference 'User.count' do
      post users_path, params: { user: { name: "uouo",
                                          email: "user@uouo.com",
                                          password: "hogehoge", 
                                          password_confirmation: "hogehoge"}}
      end
    
      follow_redirect! ## follow_redirectはメソッド、!がついてるから失敗すると例外で失敗する
      assert_template 'users/show'
      # assert_select "div.nav"	 ### 例えばこういうのがあるか検証できる「<div class="nav">foobar</div>」
      assert is_logged_in?
    end
end
