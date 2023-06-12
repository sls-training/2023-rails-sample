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
        data = JSON.parse(response.body, symbolize_names: true)
        case response
        when Net::HTTPSuccess
          to_users data
        else
          to_errors data
        end
      end

      private

      def to_users(data)
        data.map do |x|
          new(
            id:           x[:id],
            name:         x[:email],
            email:        x[:email],
            admin:        x[:admin],
            activated:    x[:activated],
            activated_at: x[:activated_at],
            created_at:   x[:created_at],
            updated_at:   x[:updated_at]
          )
        end
      end

      def to_errors(data)
        data[:errors].map do |x|
          Api::Error.new(name: x[:name], message: x[:message])
        end
      end
    end
  end
end
