# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SiteLayout' do
  context 'with layout' do
    # 移動
    subject(:body) { page }

    before { visit root_path }

    it('has root path') { expect(body).to have_link 'ホーム', href: root_path }
    it('has help path') { expect(body).to have_link 'ヘルプ', href: help_path }
    it('has contact path') { expect(body).to have_link 'お問い合わせ', href: contact_path }
    it('has about path') { expect(body).to have_link 'このサイトについて', href: about_path }
    it('has singup path') { expect(body).to have_link 'サインアップ', href: signup_path }
  end
end
