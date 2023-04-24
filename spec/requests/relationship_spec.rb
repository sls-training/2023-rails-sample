require 'rails_helper'
## realation頑張って作ってね
RSpec.describe 'Relationships', type: :request do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user, :noadmin) }
  let(:other) { FactoryBot.create(:user, :noadmin) }
  let!(:one) { Relationship.create(follower_id: user1.id, followed_id: user2.id) }

  describe 'POST /relationships'
  context 'without login user'
  it 'create should require logged-in user' do
    ## ログイン済みのユーザかどうか検証していく
    expect { post relationships_path }.not_to change(Relationship, :count)
    expect(response).to redirect_to login_url
  end

  context 'with login' do
    before { log_in_as(user1) }

    ## followできるかのテスト
    it 'follows a user the standard way' do
      expect { post relationships_path, params: { followed_id: other.id } }.to change { user1.following.count }.by(1)
      expect(response).to redirect_to user_path(other)
    end

    it 'follows a user with Hotwire' do
      expect { post relationships_path(format: :turbo_stream), params: { followed_id: other.id } }.to change {
        user1.following.count
      }.by(1)
    end
  end

  describe 'DELETE /relationships' do
    context 'with login' do
      before do
        log_in_as(user1)
        user1.follow(other)
        @relationship = user1.active_relationships.find_by(followed_id: other.id)
      end

      ## unfollowできるかのテスト
      it 'unfollows a user the standard way' do
        expect { delete relationship_path(@relationship) }.to change { user1.following.count }.by(-1)
        expect(response).to have_http_status :see_other
        expect(response).to redirect_to user_path(other)
      end

      it 'unfollows a user with Hotwire' do
        expect { delete relationship_path(@relationship, format: :turbo_stream) }.to change {
          user1.following.count
        }.by(-1)
      end
    end

    context 'without login' do
      it 'destroy should require logged-in user' do
        expect { delete relationship_path(one) }.not_to change(Relationship, :count)
        expect(response).to redirect_to login_url
      end
    end
  end
end
