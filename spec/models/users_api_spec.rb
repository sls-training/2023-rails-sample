# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersApi do
  describe '#create_token' do
    subject { UsersApi.create_token(email:, password:) }

    context '管理者ユーザの場合' do
      let(:email) { Rails.application.credentials.app.rails_sample_email }

      context 'emailとパスワードが正しい場合' do
        let(:password) { Rails.application.credentials.app.rails_sample_password }

        it 'アクセストークンが返る' do
          expect(subject).to have_key(:access_token)
        end
      end

      context 'パスワードが間違っている場合' do
        let(:password) { 'wrong_password' }

        it 'errorsが返る' do
          expect(subject).to have_key(:errors)
        end
      end
    end

    context '管理者でないユーザの場合' do
      let(:email) { 'example-1@railstutorial.org' }

      contexts = [
        %w[emailとパスワードが正しい場合 password],
        %w[パスワードが間違っている場合 wrong_password]
      ]
      contexts.each do |(title, password)|
        context title do
          let(:password) { password }

          it 'errorsが返る' do
            expect(subject).to have_key(:errors)
          end
        end
      end
    end
  end
end
