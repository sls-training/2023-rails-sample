require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end
  
  it "is valid with a name, email, password, password_confirmation" do
    expect(@user).to be_valid
  end
  
  it "is invalid without a name" do
    @user.name = "    "
    @user.valid?
    expect(@user.errors[:name]).to include("can't be blank")
  end
  
  it "is invalid name too long" do
    @user.name = "a" * 51
    @user.valid?
    expect(@user.errors[:name]).to include("is too long (maximum is 50 characters)")
  end
  
  it "is invalid with too long" do
    @user.email = "a" * 244 + "@example.com"
    @user.valid?
    expect(@user.errors[:email]).to include("is too long (maximum is 255 characters)")
  end
  
  it "is invalid emails" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      @user.valid?
      expect(@user.errors[:email]).to include ("is invalid")
    end
  end
    
  it "is invalid with a duplicate email address" do
      duplicate_user = @user.dup
      @user.save
      duplicate_user.valid?
      expect(duplicate_user.errors[:email]).to include ("has already been taken")
  end
  
  
  it "does not allow to be present whitespace " do
    @user.password = @user.password_confirmation = " " * 6
    @user.valid?
    expect(@user.errors[:password]).to include ("can't be blank")
    
  end
  
  it "does not allow too short password" do
    @user.password = @user.password_confirmation = "a" * 5
    @user.valid?
    expect(@user.errors[:password]).to include ("is too short (minimum is 6 characters)")
  end
  
  it "is authenticated? return false for a user with nil digest" do
    expect(@user.authenticated?(:remember, '')).to eq false
  end
  
  it "must destory associated microposts" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    expect{
      @user.destroy
    }.to change(Micropost, :count).by(-1)
  end
  
  it "follow and unfollow a user" do
    user1 = FactoryBot.create(:user, :noadmin)
    user2 = FactoryBot.create(:user, :noadmin)
    
    expect((user1).following?(user2)).to eq false
    user1.follow(user2)
    expect((user1).following?(user2)).to eq true
    
    expect(user2.followers.include?(user1)).to eq true
    user1.unfollow(user2)
    expect((user1).following?(user2)).to eq false
  
    # # ユーザーは自分自身をフォローできない
    user1.follow(user1)
    expect((user1).following?(user1)).to eq false
  end
end
