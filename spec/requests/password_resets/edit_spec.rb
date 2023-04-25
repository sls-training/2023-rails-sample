require 'rails_helper'

RSpec.describe 'PasswordNew' do
  let(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
    post password_resets_path, params: { password_reset: { email: user.email } }
    @reset_user = controller.instance_variable_get(:@user)
  end

  describe 'EDIT' do
    it 'reset with right email and right token' do
      get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
      # assert_template 'password_resets/edit'
      assert_select 'input[name=email][type=hidden][value=?]', @reset_user.email
    end

    it 'reset with wrong email' do
      get edit_password_reset_path(@reset_user.reset_token, email: '')
      expect(response).to redirect_to root_url
    end

    it 'reset with inactive user' do
      @reset_user.toggle!(:activated)
      get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
      expect(response).to redirect_to root_url
    end

    it 'reset with right email but wrong token' do
      get edit_password_reset_path('wrong token', email: @reset_user.email)
      expect(response).to redirect_to root_url
    end
  end
end
