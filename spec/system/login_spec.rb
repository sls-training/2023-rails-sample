require 'rails_helper'

RSpec.describe "Login", type: :system do
  let!(:user) {FactoryBot.create(:user)}
  include SessionsSupport 
 
 
  scenario "user creates a new micropost" do
    visit root_path
    click_link "Log in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    
    visit root_path
    expect(page).to_not include "a[href=?]", login_path
    #assert_select "a[href=?]", logout_path
    #expect(page).to_not have_content "a[href=?]", login_path
    #expect(page).to have_content "a[href=?]", logout_path
    #expect(page).to have_content "a[href=?]", user_path(user)
  end
 
end