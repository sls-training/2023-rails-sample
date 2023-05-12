# frozen_string_literal: true

module Api
  class TokensController < ApiController
    before_action :authenticate_user!, only: [:create]
    # POST /api/token
    def create
      email = params[:email]
      access_token = AccessToken.new(email:).encode
      render json: { access_token: }
    end

    private

    def authenticate_user!
      email = params[:email]
      password = params[:password]
      user = User.find_by(email:)
      return render_unauthorized unless user
      return render_forbidden unless user.admin

      render_unauthorized unless user.authenticate(password)
    end

    def render_forbidden
      render status: :forbidden, json: { message: I18n.t(:not_admin) }
    end

    def render_unauthorized
      render status: :unauthorized, json: { message: I18n.t(:missing_param) }
    end
  end
end
