# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AcessToken' do
  describe '#create' do
    subject { Api::AccessToken.create(email:, password:) }

    context '管理者でないユーザの場合' do
      let(:email) { '' }
      let(:password) { 'password' }

      context 'emailがない場合' do
        it 'errorsが返る' do
          expect(subject.errors).not_to be_empty
        end
      end

      context 'emailがある場合' do
        let(:email) { 'example-1@railstutorial.org' }

        context 'パスワードが間違っている場合' do
          let(:password) { 'wrong_password' }

          it 'errorsが返る' do
            expect(subject.errors).not_to be_empty
          end
        end

        context 'emailとパスワードが正しい場合' do
          let(:password) { 'password' }

          it 'errorsが返る' do
            expect(subject.errors).not_to be_empty
          end
        end
      end
    end

    context '管理者ユーザの場合' do
      context 'emailがない場合' do
        let(:email) { '' }
        let(:password) { 'wrong_password' }

        it 'errorsが返る' do
          expect(subject.errors).not_to be_empty
        end
      end

      context 'emailがある場合' do
        let(:email) { Rails.application.credentials.app.rails_sample_email }

        context 'パスワードが間違っている場合' do
          let(:password) { 'wrong_password' }

          it 'errorsが返る' do
            expect(subject.errors).not_to be_empty
          end
        end

        context 'emailとパスワードが正しい場合' do
          let(:password) { Rails.application.credentials.app.rails_sample_password }

          it 'アクセストークンが返る' do
            expect(subject.value).not_to be_nil
          end
        end
      end
    end
  end
end
