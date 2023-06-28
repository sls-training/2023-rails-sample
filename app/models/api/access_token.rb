# frozen_string_literal: true

require 'openapi_client'

module Api
  class AccessToken
    extend HttpMethod
    attr_reader :value

    def self.create(email:, password:)
      api_instance = OpenapiClient::TokenApi.new
      create_token_request = OpenapiClient::CreateTokenRequest.new({ email:, password: })

      # ベアラートークンを生成する
      result = api_instance.create_token(create_token_request)
      new(value: result.access_token)
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
