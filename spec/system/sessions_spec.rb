require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  before { driven_by(:rack_test) }

  describe '#new' do
    context '値が無効' do
      #visit login_path
    end
  end
  # it "gets new" do
  #   get login_path
  #   #これ下二つ同じ意味になるのか...？ be_successfulが200だけか怪しい
  #   expect(response).to be_successful
  #   expect(response).to have_http_status 200
  # end
end
