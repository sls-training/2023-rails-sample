# frozen_string_literal: true

module Api
  class TokensController < ActionController::API
    # POST /api/token
    def create
      email = params[:email]
      password = params[:password]
      user = User.find_by(email:)
      if user
        if !user.admin?
          render_forbidden
        elsif user.authenticate(password)
          access_token = AccessToken.new(email:).encode
          render json: { access_token: }
        else
          render_unauthorized
        end
      else
        render_unauthorized
      end
    end

    private

    def render_forbidden
      render status: :forbidden, json: { message: 'Access denied. You are not admin user' }
    end

    def render_unauthorized
      render status: :unauthorized, json: { message: 'Unauthorized. Make sure you have the parameters.' }
    end
  end
end
