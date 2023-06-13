# frozen_string_literal: true

module Api
  class AccessToken
    extend HttpMethod
    attr_reader :value

    def self.create(email:, password:)
      response = post(
        '/token', params:  { email:, password: },
                  headers: { 'Content-Type' => 'application/json' }
      )
      data = JSON.parse(response.body, symbolize_names: true)
      case response
      when Net::HTTPSuccess
        value = data[:access_token]
        new(value:)
      else
        errors = data[:errors]
        errors.map do |error|
          Api::Error.from_json error
        end
      end
    end

    def initialize(value: nil)
      @value = value
    end

    def expired?
      JWT.decode value, Rails.application.credentials.app.secret_access_key, true,
                 { algorithm: 'HS256' }
      false
    rescue JWT::DecodeError
      true
    end

    def valid?
      !expired?
    end
  end
end
