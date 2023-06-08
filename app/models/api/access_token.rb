# frozen_string_literal: true

module Api
  class AccessToken
    include HttpMethod
    attr_reader :value
    attr_reader :errors

    def initialize(email:, password:)
      response = post(
        '/token', params:  { email:, password: },
                  headers: { 'Content-Type' => 'application/json' }
      )
      case response
      when Net::HTTPSuccess
        data = JSON.parse(response.body, symbolize_names: true)
        @value = data[:access_token]
      when Net::HTTPUnauthorized || Net::HTTPForbidden
        data = JSON.parse(response.body, symbolize_names: true)
        @errors = data[:errors]
      else
        @errors = [name: 'access_token', message: response.value]
      end
    end
  end
end
