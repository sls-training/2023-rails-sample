require 'rails_helper'

RSpec.describe 'Microposts', type: :request do
  ##マイクロポスト付きのデータの作成の仕方がわからん
  let!(:user) { FactoryBot.create(:user) }
  let!(:other) { FactoryBot.create(:user, :noadmin) }
  let!(:micropost_list) { FactoryBot.create_list(:micropost, 50, { user_id: user.id }) }

  ##--------------------------------##
  describe 'GET /microposts' do
    context 'with login user' do
      before { log_in_as(user) }
      it 'allow to access with login' do
        get microposts_path
        assert_select 'div.pagination'
      end

      ###ここら辺とは統合テストでsystem/users_system_spec.rbとかに書くべきなんじゃないかなあ。あとまとめていい
      it 'should have micropost delete links on own profile page' do
        get user_path(user)
        assert_select 'a', text: 'delete'
      end

      it "should not have delete links on other user's profile page" do
        get user_path(other)
        assert_select 'a', { text: 'delete', count: 0 }
      end
    end
  end

  ##--------------------------------##
  describe 'POST /microposts' do
    context 'with login user' do
      before { log_in_as(user) }
      it 'does not allow to create micropost on invalid submission' do
        expect { post microposts_path, params: { micropost: { content: '' } } }.to_not change(Micropost, :count)
        assert_select 'div#error_explanation'
        assert_select 'a[href=?]', '/?page=2' # 正しいページネーションリンク
      end

      it 'allows to create micropost on valid submission' do
        content = 'This micropost really ties the room together'
        expect { post microposts_path, params: { micropost: { content: content } } }.to change(Micropost, :count).by(1)
        expect(response).to redirect_to root_url
        follow_redirect!
        expect(response.body).to include content
      end
    end

    context 'without login user'
    it 'should redirect create' do
      expect { post microposts_path, params: { micropost: { content: 'Lorem ipsum' } } }.to_not change(
        Micropost,
        :count,
      )
      expect(response).to redirect_to login_url
    end
  end
  ##--------------------------------##
  describe 'DELETE /microposts' do
    context 'with login user' do
      before { log_in_as(user) }
      it 'should be able to delete own micropost' do
        first_micropost = user.microposts.paginate(page: 1).first
        expect { delete micropost_path(first_micropost) }.to change(Micropost, :count).by(-1)
      end
      # 別のユーザのmicropostを消せてしまわないかのテスト
      it 'should redirect destroy for wrong micropost' do
        log_in_as(other)

        first_micropost = user.microposts.paginate(page: 1).first
        expect { delete micropost_path(first_micropost) }.to_not change(Micropost, :count)
        expect(response).to have_http_status :see_other
        expect(response).to redirect_to root_url
      end
    end

    context 'without login user' do
      it 'does not allow to destroy' do
        first_micropost = user.microposts.paginate(page: 1).first
        expect { delete micropost_path(first_micropost) }.to_not change(Micropost, :count)
        expect(response).to have_http_status :see_other
        expect(response).to redirect_to login_url
      end
    end
  end
end
