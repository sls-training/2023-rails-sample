# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApplicationHelper' do
  it 'full title helper' do
    expect(full_title).to eq 'Ruby on Rails Tutorial Sample App'
    expect(full_title('Help')).to eq 'Help | Ruby on Rails Tutorial Sample App'
  end
end
