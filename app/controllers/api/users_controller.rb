# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    include AccessTokenVerifiable
    before_action :validate_user_id, only: %i[show destroy]

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

      ## ユーザがすでに存在している時
      if User.exists?(email:)
        errors = [{ name: 'email', message: t('.exist_user') }]
        return render 'api/errors', locals: { errors: }, status: :unprocessable_entity
      end

      new_user = User.create(name:, email:, password:, password_confirmation:)
      if new_user.invalid?
        ## パラメータに不備があった場合
        errors = new_user.errors.map { |x| { name: x.attribute, message: x.message } }
        render 'api/errors', locals: { errors: }, status: :bad_request
      else
        # ユーザの作成に成功した場合
        render :create, locals: { user: new_user }, status: :created
      end
    end

    def destroy
      ## ユーザが自分自身だった場合
      if token_user == user
        errors = [{ name: 'user_id', message: t('.destroy_self') }]
        return render 'api/errors', locals: { errors: }, status: :unprocessable_entity
      end

      user.destroy
      head :no_content
    end

    private

    def user
      @_user ||= User.find_by(id: params[:id])
    end

    def validate_user_id
      return if user.present?

      errors =  [{ name: 'user_id', message: t('.no_user') }]
      render 'api/errors', locals: { errors: }, status: :not_found
    end
  end
end
