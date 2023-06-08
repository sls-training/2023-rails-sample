# frozen_string_literal: true

module Api
  class AccessToken
    extend HttpMethod

    class << self
      def create(email:, password:)
        response = post(
          '/token', params:  { email:, password: },
                    headers: { 'Content-Type' => 'application/json' }
        )
        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
