# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    include AccessTokenVerifiable
    before_action :validate_user_id, only: %i[show]

    # GET /api/users/:id
    def show
      render :show, status: :ok, locals: { user: }
    end

    # POST /api/users
    def create
      name = params[:name]
      email = params[:email]
      password = params[:password]

      create_user = User.create(
        name:,
        email:,
        password:,
        password_confirmation: password
      )

      status =
        if !create_user.invalid?
          :created
        elsif create_user.errors.count == 1 && User.exists?(email:)
          :unprocessable_entity
        else
          :bad_request
        end

      render :create, locals: { user: create_user }, status:
    end

    private

    def user
      @_user ||= User.find_by(id: params[:id])
    end

    def validate_user_id
      return if user.present?

      render :show, status: :not_found, locals: { user: }
    end
  end
end
