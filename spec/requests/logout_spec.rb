require 'rails_helper'

RSpec.describe 'Logout' do
  let(:user) { FactoryBot.create(:user) }

  before do
    # ログインさせとく
    log_in_as(user)
    expect(is_logged_in?).to eq true
  end

  describe 'Delete /logout' do
    it 'responds successfully' do
      delete logout_path
      expect(is_logged_in?).to eq false
      expect(response).to have_http_status :see_other
      expect(response).to redirect_to root_url

      ## ログアウトした後のリダイレクト先の検証
      follow_redirect!
      assert_select 'a[href=?]', login_path
      assert_select 'a[href=?]', logout_path, count: 0
      assert_select 'a[href=?]', user_path(user), count: 0
    end

    it 'stills work after logout in second window' do
      delete logout_path
      expect(response).to redirect_to root_url
    end
  end
end
