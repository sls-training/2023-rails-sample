# frozen_string_literal: true

module Api
  class UsersController < ApiController
    # GET /api/users/:id
    def show
      user = User.find_by(id: params[:id])
      return render_user_nil if user.nil?

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

    def render_user_nil
      render status: :not_found,
             json:   { message: 'Not Found. User does not exist' }
    end
  end
end
