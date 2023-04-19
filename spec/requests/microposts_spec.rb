require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  include SessionsSupport

  let!(:micropost) { FactoryBot.create(:micropost) }
  let!(:user) { FactoryBot.create(:user) }
  # it "redirect create " do
  # end
  
  # def setup
  #   @micropost = microposts(:orange)
  # end

  it "should redirect create when not logged in" do
    expect {
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    }.to_not change(Micropost, :count)
    expect(response).to redirect_to login_url
  end
  
  it "should redirect destroy when not logged in" do
    expect {
      delete micropost_path(micropost)
      }.to_not change(Micropost, :count)
      
    expect(response).to have_http_status :see_other
    expect(response).to redirect_to login_url
  end
  
  it "should redirect destroy for wrong micropost" do
    log_in_as(user)
    
    expect {
      delete micropost_path(micropost)
      }.to_not change(Micropost, :count)
      
    expect(response).to have_http_status :see_other
    expect(response).to redirect_to root_url
  end
end
