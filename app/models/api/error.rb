# frozen_string_literal: true

module Api
  class Error < StandardError
    attr_reader :errors

    def initialize(errors)
      super('')
      @errors = errors
    end
  end
end
