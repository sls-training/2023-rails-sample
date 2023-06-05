# frozen_string_literal: true

class UsersApi
  extend HttpMethod

  class << self
    def create_token(email:, password:)
      response = post(
        '/token', params:  { email:, password: },
                  headers: { 'Content-Type' => 'application/json' }
      )
      parse_body = JSON.parse(response.body, symbolize_names: true)
      access_token = parse_body[:access_token]
      access_token.nil? ? parse_body[:errors] : access_token
    end
  end
end
