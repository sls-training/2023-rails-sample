require 'rails_helper'

RSpec.describe 'UsersIndex', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:noactivated) { FactoryBot.create(:user, :noactivated) }

  describe 'GET /users/{id}' do
    context 'with user not activated' do
      it 'is correct with valid user' do
        get user_path(user)
        expect(response).to have_http_status :success
        # assert_template   "users/show"

        # assert_select 'title', full_title(user.name)
        # assert_select 'h1', text: user.name
        # assert_select 'h1>img.gravatar'
        # assert_match user.microposts.count.to_s, response.body

        ## ページネーションのテスト
        ## micropostが多分件数足りてない
        # assert_select 'div.pagination'
        # user.microposts.paginate(page: 1).each do |micropost|
        #   assert_match micropost.content, response.body
        # end
      end
    end

    context 'with user activated' do
      it 'failed' do
        get user_path(noactivated)
        expect(response).to have_http_status :see_other
        expect(response).to redirect_to root_url
      end
    end
  end
end
