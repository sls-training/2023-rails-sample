# frozen_string_literal: true

class AccessToken
  private_class_method :new
  attr_reader :email, :exp

  def self.create(email:)
    new email:, exp: (Time.zone.now + 3600).to_i
  end

  def self.from_token(token)
    payload, = JWT.decode token, Rails.application.credentials.app.secret_access_key, true,
                          { algorithm: 'HS256' }

    new(email: payload['email'], exp: payload['exp'])
  end

  def initialize(email:, exp:)
    @email = email
    @exp = exp
  end

  def encode
    payload = { email:, exp: }
    JWT.encode payload, Rails.application.credentials.app.secret_access_key, 'HS256'
  end
end
