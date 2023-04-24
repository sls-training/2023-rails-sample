require 'rails_helper'

RSpec.describe 'Contact', type: :request do
  # viewの内容を確認できる
  # render_views

  # こっちの方が綺麗な気する
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'Get /contact' do
    it 'responds successfully contact' do
      get '/contact'
      expect(response).to be_successful
      expect(response.body).to include "Contact | #{base_title}"
    end
  end
end
