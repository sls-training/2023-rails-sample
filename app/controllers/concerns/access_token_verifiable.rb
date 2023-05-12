# frozen_string_literal: true

module AccessTokenVerifiable
  extend ActiveSupport::Concern

  included do
    before_action :verify_access_token_in_header
  end

  def verify_access_token_in_header
    access_token = request.headers['Authorization']
    return render json: { message: I18n.t(:missing_token) }, status: :unauthorized if access_token.nil?

    begin
      AccessToken.from_token(access_token[7..])
    rescue JWT::DecodeError
      render json: { message: I18n.t(:invalid_token) }, status: :unauthorized
    end
  end
end
