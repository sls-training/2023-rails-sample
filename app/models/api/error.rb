# frozen_string_literal: true

module Api
  class Error
    attr_reader :name, :message

    def initialize(name:, message:)
      @name = name
      @message = message
    end
  end
end
