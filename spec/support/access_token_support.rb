# frozen_string_literal: true

module AccessTokenSupport
  def expired_access_token
    email = 'test@example.com'
    issued_at = 11.hours.ago
    expired_at = issued_at + 1.hour
    payload = { sub: email, iat: issued_at.to_i, exp: expired_at.to_i }
    JWT.encode payload, Rails.application.credentials.app.secret_access_key, 'HS256'
  end
end
RSpec.configure { |config| config.include AccessTokenSupport }
