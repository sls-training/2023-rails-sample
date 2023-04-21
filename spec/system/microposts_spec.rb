require 'rails_helper'

RSpec.describe 'Microposts', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  #include SessionsSupport

  scenario 'user creates a new micropost' do
    visit root_path
    click_link 'Log in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    visit root_path
    expect {
      fill_in 'micropost[content]', with: 'Test Message'
      click_button 'Post'
      expect(page).to have_content 'Micropost created!'
      expect(page).to have_content 'Test Message'
    }.to change(user.microposts, :count).by(1)
  end
  #expect(page).to have_css('#record')

  # textarea = find('#course_body')
  # expect(textarea.value).to match

  #fill_in "Content", with: "uououo"
  #click_button "commit"
  # fill_in "Message", with: "My book cover"
  # attach_file "Attachment", "#{Rails.root}/spec/files/kitten.jpg"
  # expect(page).to have_content "UOuo"
end
