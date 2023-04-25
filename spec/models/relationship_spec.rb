require 'rails_helper'

RSpec.describe Relationship do
  let!(:user1) { FactoryBot.create(:user, :noadmin) }
  let!(:user2) { FactoryBot.create(:user, :noadmin) }

  let!(:relationship) { Relationship.new(follower_id: user1.id, followed_id: user2.id) }

  it 'is valid relationship' do
    relationship.valid?
    expect(relationship).to be_valid
  end

  it 'is invalid without follower_id' do
    relationship.follower_id = nil
    relationship.valid?
    expect(relationship.errors[:follower_id]).to include ("can't be blank")
  end

  it 'is invalid without followed_id' do
    relationship.followed_id = nil
    relationship.valid?
    expect(relationship.errors[:followed_id]).to include ("can't be blank")
  end
end
