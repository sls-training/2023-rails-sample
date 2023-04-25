require 'rails_helper'

RSpec.describe 'About' do
  # viewの内容を確認できる
  # render_views

  # こっちの方が綺麗な気する
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'Get /about' do
    it 'responds successfully about' do
      get '/about'
      expect(response).to be_successful
      expect(response.body).to include "About | #{base_title}"
    end
  end
end
