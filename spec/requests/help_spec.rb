# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Help' do
  # viewの内容を確認できる
  # render_views

  # こっちの方が綺麗な気する
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'Get /help' do
    it 'responds successfully help' do
      get '/help'
      expect(response).to be_successful
      expect(response.body).to include "Help | #{base_title}"
      # assert_select "title", "Help | #{base_title}"
    end
  end
end
