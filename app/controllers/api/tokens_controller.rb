# frozen_string_literal: true

module Api
  class TokensController < ActionController::API
    # POST /api/token
    def create
      email =  token_params[:email]
      password = token_params[:password]
      user = User.find_by(email:)
      if user
        if !user.admin?
          render_forbidden
        elsif User.inspect(password, user.password_digest)
          access_token = TokenUtil.encode({ email: })
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

    def token_params
      params.require(:token).permit(:email, :password)
    end
  end
end
