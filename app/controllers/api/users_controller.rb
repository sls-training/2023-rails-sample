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
      password_confirmation = password
      if User.exists?(email:)
        errors = [{ name: 'email', message: t('.exist_user') }]
        return render 'shared/api/_error', locals: { errors: }, status: :unprocessable_entity
      end

      new_user = User.create(name:, email:, password:, password_confirmation:)
      if new_user.invalid?
        errors = new_user.errors.map { |x| { name: x.attribute, message: x.message } }
        render 'shared/api/_error', locals: { errors: }, status: :bad_request
      else
        render :create, locals: { user: new_user }, status: :created
      end
    end

    private

    def user
      @_user ||= User.find_by(id: params[:id])
    end

    def validate_user_id
      return if user.present?

      errors =  [{ name: 'user_id', message: t('.no_user') }]
      render 'shared/api/_error', locals: { errors: }, status: :not_found
    end
  end
end
