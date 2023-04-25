# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersFollowing' do
  let!(:user) { create(:user) }
  let!(:f1) { create(:user, :noadmin) }

  describe 'GET /users/{id}/following' do
    context 'with login user' do
      before do
        log_in_as(user)
        user.follow(f1)
      end

      it 'allows to access' do
        get following_user_path(user)
        expect(response).to have_http_status :unprocessable_entity
        expect(user.following).not_to be_empty
        expect(response.body).to include user.following.count.to_s
        user.following.each { |user| assert_select 'a[href=?]', user_path(user) }
      end
    end

    context 'without login' do
      it 'does not allow to show without login' do
        get following_user_path(user)
        expect(response).to have_http_status :see_other
        expect(response).to redirect_to login_path
      end
    end
  end
end
