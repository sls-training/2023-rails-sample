require 'rails_helper'
##########################
## /users
##########################
RSpec.describe 'Users', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:noadmin) { FactoryBot.create(:user, :noadmin) }
  let!(:noactivated) { FactoryBot.create(:user, :noactivated) }
  let(:user_list) { FactoryBot.create_list(:user, 50, :noadmin) }
  # let!(:microposts) { FactoryBot.create_list(:micropost, 50) }

  describe 'GET /users' do
    #####################
    ## Adminユーザの場合 ##
    #####################

    context 'with admin user' do
      before do
        log_in_as(user)
        get users_path
      end

      it 'can access' do
        expect(response).to have_http_status :ok
      end

      it 'paginate users' do
        expect(response.body).not_to include 'pagination'
        # とりあえずユーザこれで作ってタグの確認する
        expect(user_list.count).to eq 50
        get users_path
        expect(response.body).to include 'pagination'
      end
    end

    ######################
    ## Normalユーザの場合 ##
    ######################
    context 'with no admin user' do
      before do
        log_in_as(noadmin)
        get users_path
      end

      it 'can access' do
        expect(response).to have_http_status :ok
      end
    end
  end

  #####################
  ## ログインなしの場合 ##
  #####################
  context 'without login' do
    it 'redirects index when not logged in' do
      get users_path
      expect(response).to redirect_to login_url
    end
  end
end
