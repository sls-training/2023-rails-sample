# frozen_string_literal: true

module AccessTokenVerifiable
  extend ActiveSupport::Concern

  included do
    before_action :verify_access_token_in_header
  end

  def raw_access_token
    @raw_access_token ||= request.headers['Authorization']&.match(/Bearer (?<token>.+)/)&.[](:token)
  end

  def access_token
    @_access_token ||= AccessToken.from_token(raw_access_token) if raw_access_token.present?
  end

  def current_user
    @_current_user ||= User.find_by(email: access_token&.email)
  end

  def verify_access_token_in_header
    render_missing_token and return if raw_access_token.nil?

    begin
      access_token
    rescue JWT::DecodeError
      render_invalid_token
    end
  end

  private

  def render_missing_token
    errors = [{ name: 'access_token', message: t('concerns.access_token_verifiable.missing_token') }]
    render 'api/errors',
           locals: { errors: }, status: :bad_request
  end

  def render_invalid_token
    errors = [{ name: 'access_token', message: t('concerns.access_token_verifiable.invalid_token') }]
    render 'api/errors',
           locals: { errors: }, status: :unauthorized
  end
end
