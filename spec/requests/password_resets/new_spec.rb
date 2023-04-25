require 'rails_helper'

RSpec.describe 'PasswordReset' do
  let(:user) { FactoryBot.create(:user) }

  before { ActionMailer::Base.deliveries.clear }

  describe 'GET /password_resets/new' do
    it 'password reset path' do
      get new_password_reset_path
      assert_select 'input[name=?]', 'password_reset[email]'
    end
  end

  describe 'EDIT' do
    before do
      # パスワードリセットのトークンを作成する
      post password_resets_path, params: { password_reset: { email: user.email } }
      @reset_user = controller.instance_variable_get('@user')
    end

    it 'reset with right email and right token' do
      get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
      # assert_template 'password_resets/edit'
      assert_select 'input[name=email][type=hidden][value=?]', @reset_user.email
    end
  end
end
