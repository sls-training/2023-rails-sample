require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  
  it "gets new" do
    get login_path
    expect(response).to be_successful
    expect(response).to have_http_status 200
  end
end
