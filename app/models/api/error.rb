# frozen_string_literal: true

module Api
  class Error < StandardError
    def self.from_json(json)
      Api::Error.new(msg: json)
    end

    def initialize(msg:)
      super msg
    end
  end
end
