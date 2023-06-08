# frozen_string_literal: true

module Api
  class AccessToken
    include HttpMethod
    attr_reader :value
    attr_reader :errors

    def create(email:, password:)
      response = post(
        '/token', params:  { email:, password: },
                  headers: { 'Content-Type' => 'application/json' }
      )
      data = JSON.parse(response.body, symbolize_names: true)
      case response
      when Net::HTTPSuccess
        @value = data[:access_token]
      else
        @errors = data[:errors]
      end
    end
  end
end
