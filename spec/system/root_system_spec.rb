# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RootSystem' do
  let!(:user) { create(:user) }

  it 'feeds on Home page' do
    visit root_path
    user.feed.paginate(page: 1).each do |micropost|
      # 得られるHTMLのソースコードと一致しないマイクロポストのコンテンツ
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end
end
