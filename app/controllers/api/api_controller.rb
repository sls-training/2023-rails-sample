# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    include VerifyTokens
    def t(key, options = {})
      I18n.t("#{controller_name}_controller.#{key}", **options)
    end
  end
end
