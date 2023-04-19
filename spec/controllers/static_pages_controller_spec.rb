require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  # viewの内容を確認できる
  render_views

  #こっちの方が綺麗な気する
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }
  describe "static pages" do
    # before do
    #   @base_title = "Ruby on Rails Tutorial Sample App"
    # end
    
    it "responds successfully root" do
      get :home
      expect(response).to be_successful
      assert_select "title", "Home | #{base_title}"
    end
    
    it "responds successfully help" do
      get :help
      expect(response).to be_successful
      assert_select "title", "Help | #{base_title}"
      
    end
    
    it "responds successfully about" do
      get :about
      expect(response).to be_successful
      assert_select "title", "About | #{base_title}"
    end
    
    it "responds successfully contact" do
      get :contact
      expect(response).to be_successful
      assert_select "title", "Contact | #{base_title}"
    end
  end
end
# root 'static_pages#home'
#   get '/help', to:'static_pages#help'
#   get '/about', to: 'static_pages#about'
#   get '/contact', to: 'static_pages#contact'
  
  ## user

# def setup 
#     @base_title = "Ruby on Rails Tutorial Sample App"
#   end

#   test "should get root" do
#     get root_url
#     assert_response :success
#     assert_select "title", "Home | #{@base_title}"
#   end

#   test "should get help" do
#     get help_url
#     assert_response :success
#     assert_select "title", "Help | #{@base_title}"
#   end
#   test "should get about" do
#     get about_url
#     assert_response :success
#     assert_select "title", "About | #{@base_title}"
#   end
#   test "should get contact" do
#     get contact_url
#     assert_response :success
#     assert_select "title", "Contact | #{@base_title}"
#   end