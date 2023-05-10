# frozen_string_literal: true

module Api
  class UsersController < ApiController
    # GET /api/users/:id
    def show
      render json: User.select(
        :id,
        :name,
        :email,
        :created_at,
        :updated_at,
        :admin,
        :activated,
        :activated_at
      ).find(params[:id])
    end
  end
end
