# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Followers' do
  let!(:user) { create(:user) }
  let!(:f1) { create(:user, :noadmin) }

  # let(:relationship) { FactoryBot.create(:relationship) }
  describe 'GET /users/{id}/followers' do
    context 'with login user' do
      before do
        log_in_as(user)
        # user.follow(f1)
        f1.follow(user)
      end

      it 'followers page' do
        get followers_user_path(user)
        expect(response).to have_http_status :unprocessable_entity

        # follwersの中身がない状態で次のテストが行われるとスルーされてしまい検証できない
        expect(user.followers).not_to be_empty
        expect(response.body).to include user.followers.count.to_s
        user.followers.each { |user| assert_select 'a[href=?]', user_path(user) }
      end
    end
  end

  context 'without login' do
    it 'does not allow to show without login' do
      get followers_user_path(user)
      expect(response).to have_http_status :see_other
      expect(response).to redirect_to login_path
    end
  end
end
