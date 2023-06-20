# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Microposts' do
  let!(:user) { create(:user) }
  # include SessionsSupport

  before do
    WebMock.stub_request(:post, 'http://localhost:3000/api/token')
      .with(body: { email: user.email, password: user.password })
      .to_return(body: { access_token: AccessToken.new(email: user.email).encode }.to_json, status: 200, headers: { 'Content-Type' => 'application/json' })
  end

  it 'user creates a new micropost' do
    visit root_path
    click_link 'ログイン'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    visit root_path
    expect do
      fill_in 'micropost[content]', with: 'Test Message'
      click_button 'Post'
      expect(page).to have_content 'Micropost created!'
      expect(page).to have_content 'Test Message'
    end.to change(user.microposts, :count).by(1)
  end
  # expect(page).to have_css('#record')

  # textarea = find('#course_body')
  # expect(textarea.value).to match

  # fill_in "Content", with: "uououo"
  # click_button "commit"
  # fill_in "Message", with: "My book cover"
  # attach_file "Attachment", "#{Rails.root}/spec/files/kitten.jpg"
  # expect(page).to have_content "UOuo"
end
