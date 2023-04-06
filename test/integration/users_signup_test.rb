require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
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
      #assert_response :unprocessable_entity
      assert_template 'users/new'
    end
end
