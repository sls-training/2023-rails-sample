# frozen_string_literal: true

module AccessTokenVerifiable
  extend ActiveSupport::Concern

  included do
    before_action :verify_access_token_in_header
  end

  def verify_access_token_in_header
    access_token = request.headers['Authorization']
    if access_token.nil?
      return render json:   { message: t('concerns.access_token_verifiable.missing_token') },
                    status: :unauthorized
    end

    begin
      AccessToken.from_token(access_token[7..])
    rescue JWT::DecodeError
      render json: { message: t('concerns.access_token_verifiable.invalid_token') }, status: :unauthorized
    end
  end
end
