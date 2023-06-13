# frozen_string_literal: true

module Api
  class User
    extend HttpMethod
    attr_reader :id, :name, :email, :admin, :activated, :activated_at, :created_at, :updated_at

    attr

    def initialize(id:, name:, email:, admin:, activated:, activated_at:, created_at:, updated_at:)
      @id = id
      @name = name
      @email = email
      @admin = admin
      @activated = activated
      @activated_at = activated_at
      @created_at = created_at
      @updated_at = updated_at
    end

    class << self
      def get_list(access_token:, sort_by: 'name', order_by: 'asc', limit: 50, offset: 0)
        headers = { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{access_token}" }
        response = get('/users', params: { sort_by:, order_by:, limit:, offset: }, headers:)
        users = JSON.parse(response.body, symbolize_names: true)
        case response
        when Net::HTTPSuccess
          users.map do |user|
            from_json user
          end

        else
          users[:errors].map do |error|
            Api::Error.from_json error
          end
        end
      end

      def from_json(json)
        new(
          id:           json[:id],
          name:         json[:email],
          email:        json[:email],
          admin:        json[:admin],
          activated:    json[:activated],
          activated_at: json[:activated_at],
          created_at:   json[:created_at],
          updated_at:   json[:updated_at]
        )
      end
    end
  end
end
