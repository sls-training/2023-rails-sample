require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:micropost) { user.microposts.build(content: "Lorem ipsum") }
  let!(:most_recent) {FactoryBot.create(:micropost,:most_recent)}
  
  it "is valid micropost" do
    micropost.valid?
    expect(micropost).to be_valid
  end
  
  it "is invalid without user_id" do
    micropost.user_id = nil
    micropost.valid?
    expect(micropost.errors[:user_id]).to include ("can't be blank")
  end
  
  it "is invalid without content" do 
    micropost.content = "   "
    micropost.valid?
    expect(micropost.errors[:content]).to include("can't be blank")
  end
  
  it "is invalid with too long content" do 
    micropost.content = "a" * 141
    micropost.valid?
    expect(micropost.errors[:content]).to include("is too long (maximum is 140 characters)")
  end
  
  it "is first with order most recent" do
      expect(most_recent).to eq Micropost.first
  end
end
