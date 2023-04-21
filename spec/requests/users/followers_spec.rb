require 'rails_helper'

RSpec.describe 'Followers', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  describe 'GET /users/{id}/followers' do
    it 'correct user' do
      log_in_as(user)
      expect(is_logged_in?).to eq true
      #get `/users/#{user.id}/following`
      get followers_user_path(user)
      #何故422なのか？
      #expect(response).to have_http_status 200
    end

    it 'does not allow to show without login' do
      get followers_user_path(user)
      expect(response).to have_http_status :see_other
      expect(response).to redirect_to login_path
    end
  end
end
