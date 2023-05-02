# frozen_string_literal: true

module Api
  class TokenController < ActionController::API
    # POST /api/token
    def create
      email =  token_params[:email]
      password = token_params[:password]
      user = User.find_by(email: email)
      if User.inspect(password, user.password_digest)
        token = encode(user.name)

        render json: token
      else
        render json: 'failed'
      end
    end

    def update_token(user)
      user.update_attribute(:access_token, token)
    end

    def encode(name)
      payload = { data: name, exp: (Time.zone.now + 3600).to_i }
      JWT.encode payload, Rails.application.credentials.secret_key_base, 'HS256'
    end

    def decode(token)
      JWT.decode token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' }
    end

    private

    def token_params
      params.require(:token).permit(:email, :password)
    end
  end
end
