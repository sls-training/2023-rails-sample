# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    include AbstractController::Translation
  end
end
