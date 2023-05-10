# frozen_string_literal: true

module Api
  class UsersController < ApiController
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
  end
end
