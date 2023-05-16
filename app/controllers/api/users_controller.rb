# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    include AccessTokenVerifiable
    before_action :validate_user_id, only: %i[show]
    # GET /api/users/:id
    def show
      render_user user, :ok
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
        password_confirmation: password,
        activated:             false
      )
      create_user.invalid? ? render_create_failed(create_user) : render_user(create_user, :created)
    end

    private

    def user
      @_user ||= User.find_by(id: params[:id])
    end

    def render_user(target, status)
      render status:, json: {
        id:           target.id,
        name:         target.name,
        email:        target.email,
        admin:        target.admin,
        activated:    target.activated,
        activated_at: target.activated_at&.iso8601(2),
        created_at:   target.created_at.iso8601(2),
        updated_at:   target.updated_at.iso8601(2)
      }
    end

    def render_create_failed(create_user)
      errors = create_user.errors.map { |err| { name: err.attribute, message: err.message } }
      is_exist = errors.length == 1 && errors.first[:message] == 'has already been taken'
      status = is_exist ? :unprocessable_entity : :bad_request
      render status:, json: { errors: }
    end

    def validate_user_id
      return if user.present?

      render status: :not_found,
             json:   { errors: { name: 'user_id', message: t('.no_user') } }
    end
  end
end
