# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessToken' do
  describe '#create' do
    subject { Api::AccessToken.create(email:, password:) }

    context '管理者でないユーザの場合' do
      let(:email) { '' }
      let(:password) { 'password' }

      context 'emailがない場合' do
        before do
          WebMock
            .stub_request(:post, 'http://localhost:3000/api/token')
            .with(body: { email:, password: })
            .to_return(
              body:   {
                errors: [
                  {
                    name:    'access_token',
                    message: 'Incorrect email or password'
                  }
                ]
              }.to_json,
              status: 400
            )
        end

        it 'errorが返る' do
          expect(subject).to include Api::Error
        end
      end

      context 'emailがある場合' do
        let(:email) { 'example-1@railstutorial.org' }

        context 'パスワードが間違っている場合' do
          let(:password) { 'wrong_password' }

          before do
            WebMock
              .stub_request(:post, 'http://localhost:3000/api/token')
              .with(body: { email:, password: })
              .to_return(
                body:   {
                  errors: [
                    {
                      name:    'access_token',
                      message: 'Incorrect email or password'
                    }
                  ]
                }.to_json,
                status: 400
              )
          end

          it 'errorが返る' do
            expect(subject).to include Api::Error
          end
        end

        context 'emailとパスワードが正しい場合' do
          let(:password) { 'password' }

          before do
            WebMock
              .stub_request(:post, 'http://localhost:3000/api/token')
              .with(body: { email:, password: })
              .to_return(
                body:   {
                  errors: [
                    {
                      name:    'access_token',
                      message: 'You are not admin user'
                    }
                  ]
                }.to_json,
                status: 403
              )
          end

          it 'errorが返る' do
            expect(subject).to include Api::Error
          end
        end
      end
    end

    context '管理者ユーザの場合' do
      context 'emailがない場合' do
        let(:email) { '' }
        let(:password) { 'wrong_password' }

        before do
          WebMock
            .stub_request(:post, 'http://localhost:3000/api/token')
            .with(body: { email:, password: })
            .to_return(
              body:   {
                errors: [
                  {
                    name:    'access_token',
                    message: 'Incorrect email or password'
                  }
                ]
              }.to_json,
              status: 400
            )
        end

        it 'errorが返る' do
          expect(subject).to include Api::Error
        end
      end

      context 'emailがある場合' do
        let(:email) { Rails.application.credentials.app.rails_sample_email }

        context 'パスワードが間違っている場合' do
          let(:password) { 'wrong_password' }

          before do
            WebMock
              .stub_request(:post, 'http://localhost:3000/api/token')
              .with(body: { email:, password: })
              .to_return(
                body:   {
                  errors: [
                    {
                      name:    'access_token',
                      message: 'Incorrect email or password'
                    }
                  ]
                }.to_json,
                status: 400
              )
          end

          it 'errorが返る' do
            expect(subject).to include Api::Error
          end
        end

        context 'emailとパスワードが正しい場合' do
          let(:password) { Rails.application.credentials.app.rails_sample_password }

          before do
            WebMock
              .stub_request(:post, 'http://localhost:3000/api/token')
              .with(body: { email:, password: })
              .to_return(
                body:   {
                  access_token: AccessToken.new(email:).encode
                }.to_json,
                status: 200
              )
          end

          it 'アクセストークンが返る' do
            expect(subject.value).not_to be_nil
          end
        end
      end
    end
  end
end
