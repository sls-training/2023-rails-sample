# frozen_string_literal: true

module AccessTokenVerifiableForApi
  extend ActiveSupport::Concern

  EMAIL = Rails.application.credentials.app.rails_sample_email
  PASSWORD = Rails.application.credentials.app.rails_sample_password

  included do
    before_action :generate_and_verfiy_access_token
  end

  def raw_access_token
    @raw_access_token ||= UsersApi.create_token(email: EMAIL, password: PASSWORD)
  end

  def access_token
    @_access_token ||= AccessToken.from_token(raw_access_token) if raw_access_token.present?
  end

  private

  def generate_and_verfiy_access_token
    redirect_to_login and return if raw_access_token.nil?

    begin
      access_token
    rescue JWT::DecodeError
      redirect_to_login
    end
  end

  def redirect_to_login
    redirect_to login_url, flash: { danger: 'ログインし直してください' }
  end
end
