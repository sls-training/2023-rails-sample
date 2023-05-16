# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include AbstractController::Translation
  end
end
