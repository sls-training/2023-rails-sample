# frozen_string_literal: true

module Api
  class UsersController < ApiController
    before_action :validate_user_id

    # GET /api/users/:id
    def show
      user = User.find(params[:id])

      render json: {
        id:           user.id,
        name:         user.name,
        email:        user.email,
        admin:        user.admin,
        activated:    user.activated,
        activated_at: user.activated_at.iso8601(2),
        created_at:   user.created_at.iso8601(2),
        updated_at:   user.updated_at.iso8601(2)
      }
    end

    private

    def validate_user_id
      return if User.exists?(id: params[:id])

      render status: :not_found,
             json:   { message: 'Not Found. User with this ID does not exist' }
    end
  end
end
