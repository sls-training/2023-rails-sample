require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }
  describe 'static pages' do
    it 'responds successfully root' do
      get root_path
      expect(response).to be_successful
      expect(response.body).to include "Home | #{base_title}"
    end
  end
end
