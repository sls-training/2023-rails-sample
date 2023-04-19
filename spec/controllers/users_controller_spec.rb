require 'rails_helper'

RSpec.describe UsersController, type: :controller do
   #get '/signup', to: 'users#new'
  describe 'users#new' do
    # it "responds successfully" do
    #   get signup_path
    #   expect(response).to be_successful
    # end
  end
end


# def setup
#     @user = users(:michael)
#     @other_user = users(:archer)
#   end
#   test "should get new" do
#     get signup_path
#     assert_response :success
#   end
  
#   # ログインしてるユーザはユーザの一覧ページが見れる
#   test "should redirect index when not logged in" do
#     get users_path
#     assert_redirected_to login_url
#   end
  
#   # フォローとフォロワーページの認可のテスト
#   test "should redirect following when not logged in" do
#     get following_user_path(@user)
#     assert_redirected_to login_url
#   end

#   test "should redirect followers when not logged in" do
#     get followers_user_path(@user)
#     assert_redirected_to login_url
#   end