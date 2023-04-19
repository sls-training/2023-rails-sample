require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let!(:user1) { FactoryBot.create(:user)}
  let!(:user2) { FactoryBot.create(:user)}
  let!(:one) { Relationship.create(follower_id: user1.id, followed_id: user2.id)}
  
  describe "GET /relationships" do
    it"create should require logged-in user" do
    
      ## ログイン済みのユーザかどうか検証していく
      expect{ 
        post relationships_path
      }.to_not change(Relationship, :count)
      expect(response).to redirect_to login_url
    end

    it "destroy should require logged-in user" do
      expect{ 
        delete relationship_path(one)
      }.to_not change(Relationship, :count)
      expect(response).to redirect_to login_url
    end
  end
end
