# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
    before_action :require_access_token

    protected

    def require_access_token
      access_token = request.headers['Authorization']
      return render json: { message: 'Missing authentication token' }, status: :unauthorized if access_token.nil?

      begin
        AccessToken.from_token(access_token[7..])
      rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError
        render json: { message: 'Unauthorized. Invalid token' }, status: :unauthorized
      end
    end
  end
end
