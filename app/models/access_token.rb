# frozen_string_literal: true

class AccessToken
  attr_reader :email

  # @param encoded_token [String]
  # @return [AccessToken]
  def self.from_token(encoded_token)
    payload, = JWT.decode encoded_token, Rails.application.credentials.app.secret_access_key, true,
                          { algorithm: 'HS256' }

    new(email: payload[:sub])
  end

  # @param email [String]
  # @return [self]
  def initialize(email:)
    @email = email
  end

  # @return [String]
  def encode
    JWT.encode to_payload, Rails.application.credentials.app.secret_access_key, 'HS256'
  end

  # @return {sub : [String], iat: [Integer], exp: [Integer]}
  def to_payload
    issued_at = Time.current
    expired_at = Time.current.now + 1.hour
    { sub: email, iat: issued_at.to_i, exp: expired_at.to_i }
  end
end
