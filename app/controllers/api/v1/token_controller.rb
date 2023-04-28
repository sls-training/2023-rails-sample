# frozen_string_literal: true

module Api
  module V1
    class TokenController < ActionController::API
      # POST /api/v1/token
      def create
        email =  params[:email]
        password = params[:password]
        user = User.find_by(email: email)

        if user && User.inspect(password, user.password_digest)
          token = encode(user.name)
          render json: { token_type: 'bearer', access_token: token }
        else
          render status: :unauthorized, json: { message: 'Access denied. you are not admin user' }
        end
      end

      def update_token(user)
        user.update_attribute(:authenticate_token, token)
      end

      def encode(name)
        payload = { data: name, exp: (Time.zone.now + 3600).to_i }
        JWT.encode payload, Rails.application.credentials.secret_key_base, 'HS256'
      end

      def decode(token)
        JWT.decode token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' }
      end
    end
  end
end
