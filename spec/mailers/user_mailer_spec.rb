require 'rails_helper'

RSpec.describe 'UserMailler', type: :mailer do
  let!(:user) { FactoryBot.create(:user) }

  it 'account_activation' do
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    expect(mail.subject).to eq 'Account activation'
    expect(mail.to).to eq [user.email]
    expect(mail.from).to eq ['sakisaki200012@gmail.com']
    expect(mail.body.encoded).to include user.name
    expect(mail.body.encoded).to
    include user.activation_token
    expect(mail.body.encoded).to include CGI.escape(user.email)
  end

  it 'password_reset' do
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    expect(mail.subject).to eq 'Password reset'
    expect(mail.to).to eq [user.email]
    expect(mail.from).to eq ['sakisaki200012@gmail.com']
    expect(mail.body.encoded).to include user.reset_token
    expect(mail.body.encoded).to include CGI.escape(user.email)
  end
end
