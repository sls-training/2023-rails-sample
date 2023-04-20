require 'rails_helper'

RSpec.describe "SiteLayout", type: :system do

  context "layout links" do
    # 移動
    before do 
      visit root_path
    end
    subject { page }
    it "uouo" do
      is_expected.to have_link 'Home', href: root_path
      is_expected.to have_link 'Help', href: help_path
      is_expected.to have_link 'About', href: about_path
      is_expected.to have_link 'Contact', href: contact_path
      is_expected.to have_link 'Sign up now!', href: signup_path
    end
  end
end
