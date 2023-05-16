# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    include AccessTokenVerifiable
    before_action :validate_user_id, only: %i[show]
    # GET /api/users/:id
    def show
      render_user user
    end

    private

    def user
      @_user ||= User.find_by(id: params[:id])
    end

    def render_user(user)
      render status: :ok, json: {
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

    def validate_user_id
      return if user.present?

      render status: :not_found,
             json:   { errors: { name: 'user_id', message: t('.no_user') } }
    end
  end
end
