# frozen_string_literal: true

class UsersApi
  extend HttpMethod

  class << self
    def create_token(email:, password:)
      response = post(
        '/token', params:  { email:, password: },
                  headers: { 'Content-Type' => 'application/json' }
      )
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
