# frozen_string_literal: true

module Api
  class AccessToken
    extend HttpMethod
    attr_reader :value
    attr_reader :errors

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
        new(errors:)
      end
    end

    def initialize(value: nil, errors: nil)
      @value = value
      @errors = errors
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
