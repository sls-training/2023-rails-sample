# frozen_string_literal: true

module Api
  class User
    extend HttpMethod

    class << self
      def get_list(access_token:, sort_by: 'name', order_by: 'asc', limit: 50, offset: 0)
        headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{access_token}" }
        response = get('/users', params: { sort_by:, order_by:, limit:, offset: }, headers:)
        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
