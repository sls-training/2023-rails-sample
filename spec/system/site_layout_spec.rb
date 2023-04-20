require 'rails_helper'

RSpec.describe "SiteLayout", type: :system do

  context "layout links" do
    # 移動
    it "uouo" do
      visit root_path
      assert_select "a[href=?]", root_path
      assert_select "a[href=?]", help_path
      assert_select "a[href=?]", about_path
      assert_select "a[href=?]", contact_path
      assert_select "a[href=?]", signup_path
    end
    # before do
    #   visit root_path
      
    # end
  
    # subject { page }
    
    # it 'render to /' do
    #   # 内容の検証
    #   assert_select "a[href=?]", root_path
    #   #is_expected.to have_content(root_path)
    #   # is_expected.to have_current_path root_path
    # end
    
    # #assert_template 'static_pages/home'
    # assert_select "a[href=?]", root_path
    # assert_select "a[href=?]", help_path
    # assert_select "a[href=?]", about_path
    # assert_select "a[href=?]", contact_path
    # assert_select "a[href=?]", signup_path
  end
end
