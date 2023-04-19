require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
   # viewの内容を確認できる
  #render_views

  #こっちの方が綺麗な気する
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }
  describe "static pages" do
    # before do
    #   @base_title = "Ruby on Rails Tutorial Sample App"
    # end
    
    it "responds successfully root" do
      get root_path
      expect(response).to be_successful
      
      assert_select "title", "Home | #{base_title}"
    end
    
    it "responds successfully help" do
      get "/help"
      expect(response).to be_successful
      assert_select "title", "Help | #{base_title}"
      
    end
    
    it "responds successfully about" do
      get "/about"
      expect(response).to be_successful
      assert_select "title", "About | #{base_title}"
    end
    
    it "responds successfully contact" do
      get "/contact"
      expect(response).to be_successful
      assert_select "title", "Contact | #{base_title}"
    end
  end
end
