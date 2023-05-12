# frozen_string_literal: true

module VerifyTokens
  extend ActiveSupport::Concern

  def require_access_token
    access_token = request.headers['Authorization']
    return render json: { message: I18n.t(:missing_token) }, status: :unauthorized if access_token.nil?

    begin
      AccessToken.from_token(access_token[7..])
    rescue JWT::DecodeError
      render json: { message: I18n.t(:invalid_token) }, status: :unauthorized
    end
  end
end
