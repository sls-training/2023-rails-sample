# frozen_string_literal: true

module TokenUtil
  class << self
    def encode(data)
      payload = { **data, exp: (Time.zone.now + 3600).to_i }
      JWT.encode payload, Rails.application.credentials.app.secret_access_key, 'HS256'
    end

    def decode(token)
      JWT.decode token, Rails.application.credentials.app.secret_access_key, true,
                 { algorithm: 'HS256' }
    end
  end
end
