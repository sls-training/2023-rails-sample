# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Index' do
  let!(:user) { create(:user) }
  let!(:noadmin) { create(:user, :noadmin) }
  let!(:noactivated) { create(:user, :noactivated) }
  let!(:user_list) { create_list(:user, 50, :noadmin) }

  before do
    create_list(:micropost, 50, { user_id: user.id })
  end

  # 正味GETリクエストなんてまとめて検証した方がわかりやすい気もしてくるが...どうなんだろう
  describe 'GET /users/{id}' do
    context 'with user' do
      before do
        log_in_as(user)
        get user_path(user)
      end

      it 'allows to access' do
        expect(response).to have_http_status :success

        # 多分こっからは統合テストにかくべき
        assert_select 'title', full_title(user.name)
        assert_select 'h1', text: user.name
        assert_select 'h1>img.gravatar'
        assert_match user.microposts.count.to_s, response.body
        assert_select 'div.pagination'
        user.microposts.paginate(page: 1).each { |micropost| assert_match micropost.content, response.body }
      end
    end

    context 'without user' do
      before { get user_path(user) }

      it 'does not allow to access' do
        # ログインなくてもユーザの投稿だけは見れる
        expect(response).to have_http_status :success
        # 以下略
      end
    end
  end

  ## こういうのは統合テストだからここに書くのは違うんだろうなと
  ## APIの仕様だけまとめるだけならbodyの内容をrequestで検証するはおかしい
  describe 'DELETE /users/{id}' do
    #################
    ### Adminの場合
    ##################
    context 'with admin user' do
      before do
        user_list
        log_in_as(user)
        get users_path
      end

      ## 削除用のリンクがある

      it 'has delete links' do
        first_page_of_users = User.where(activated: true).paginate(page: 1)
        first_page_of_users.each do |u|
          assert_select 'a[href=?]', user_path(u), text: u.name
          assert_select 'a[href=?]', user_path(u), text: 'delete' unless u == user
          # イメージこんなんにできた方がいいのかもなあ => expect(response.body).to include user_path(u)
        end
      end

      ## 削除できる
      it 'can delete non-admin user' do
        expect { delete user_path(noadmin) }.to change(User, :count).by(-1)

        assert_response :see_other
        assert_redirected_to users_url
      end

      it 'displays only activated users' do
        ## ページにいる最初のユーザーを無効化する。
        ## toggle : インスタンスに保存されているbooleanの値を反転させて保存、成功すればtrue
        User.paginate(page: 1).first.toggle! :activated
        # /usersを再度取得して、無効化済みのユーザーが表示されていないことを確かめる
        get users_path
        # 表示されているすべてのユーザーが有効化済みであることを確かめる
        assigns(:users).each { |user| expect(user.activated).to be_truthy }
      end
    end

    #################
    ### Adminでない場合
    ##################
    context 'with no admin user' do
      before do
        user_list
        log_in_as(noadmin)
        get users_path
      end

      it 'does not have delete links as non-admin' do
        assert_select 'a', text: 'delete', count: 0
      end
    end

    ##########################
    ### Activateされていない場合
    ##########################
    it 'redirect when user not activated' do
      get user_path(noactivated)
      assert_response :see_other
      assert_redirected_to root_url
    end
  end
end
