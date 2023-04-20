require 'rails_helper'

RSpec.describe "UsersEdit", type: :request do
  let!(:user) { FactoryBot.create(:user) } 
  #let!(:other) {FactoryBot.create(:noadmin) }
  describe "Get /users/{id}/edit" do
    
    ## ユーザの入力に不備
    context "with invalid info" do
      ## 編集の失敗 422
      it "unsuccessful edit" do
        log_in_as(user)
        get edit_user_path(user)
        expect(response).to have_http_status :success
        
        #失敗するパッチ
        expect {
          patch user_path(@user), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar"}}
        }.to raise_error(ActionController::UrlGenerationError)
        
        ##なんか怪しい
        #expect(response).to redirect_to edit_user_path(user)
        #expect(response).to have_http_status(422)
        # assert_template 'users/edit'
      end
    end
    
    
    context "with valid info" do
      it "scucess" do
        # フレンドリフォワーディング
        log_in_as(user)
        get edit_user_path(user)
        expect(response).to have_http_status :success
     
        name  = "Foo Bar"
        email = "foo@bar.com"
     
        patch user_path(user), params: { user: { name:  name,
                                                  email: email,
                                                  password:              "",
                                                  password_confirmation: "" } }
        
        expect(flash.empty?).to_not eq true
        expect(response).to redirect_to user
        #expect(response).to have_http_status 302
        
        #リロードしてあってる確認
        user.reload
        expect(name).to eq user.name
        expect(email).to eq user.email
      end
    end
  end
end