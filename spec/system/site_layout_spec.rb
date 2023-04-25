require 'rails_helper'

RSpec.describe 'SiteLayout' do
  context 'with layout' do
    # 移動
    subject(:body) { page }

    before { visit root_path }

    it('has root path') { expect(body).to have_link 'Home', href: root_path }
    it('has help path') { expect(body).to have_link 'Help', href: help_path }
    it('has contact path') { expect(body).to have_link 'Contact', href: contact_path }
    it('has about path') { expect(body).to have_link 'About', href: about_path }
    it('has singup path') { expect(body).to have_link 'Sign up now!', href: signup_path }
  end
end
