# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserMailler' do
  let!(:user) { create(:user) }

  context 'with account_activation' do
    subject(:mail_account_activation) do
      user.activation_token = User.new_token
      UserMailer.account_activation(user)
    end

    it { expect(mail_account_activation.subject).to eq 'Account activation' }
    it { expect(mail_account_activation.to).to eq [user.email] }
    it { expect(mail_account_activation.from).to eq ['sakisaki200012@gmail.com'] }
    it { expect(mail_account_activation.body.encoded).to include user.name }
    it { expect(mail_account_activation.body.encoded).to include user.activation_token }
    it { expect(mail_account_activation.body.encoded).to include CGI.escape(user.email) }
  end

  context 'with password_reset' do
    subject(:mail_resest_password) do
      user.reset_token = User.new_token
      UserMailer.password_reset(user)
    end

    it { expect(mail_resest_password.subject).to eq 'Password reset' }
    it { expect(mail_resest_password.to).to eq [user.email] }
    it { expect(mail_resest_password.from).to eq ['sakisaki200012@gmail.com'] }
    it { expect(mail_resest_password.body.encoded).to include user.reset_token }
    it { expect(mail_resest_password.body.encoded).to include CGI.escape(user.email) }
  end
end
