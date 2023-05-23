# frozen_string_literal: true

module AccessTokenVerifiable
  extend ActiveSupport::Concern

  included do
    before_action :verify_access_token_in_header
  end

  def verify_access_token_in_header
    authorization_header = request.headers['Authorization']
    access_token = authorization_header&.match(/Bearer (?<token>.+)/)&.[](:token)

    render_missing_token and return if access_token.nil?

    begin
      AccessToken.from_token(access_token)
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
