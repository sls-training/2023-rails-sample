# frozen_string_literal: true

module Api
  class Error
    attr_reader :name, :message

    def self.from_json(json)
      Api::Error.new(name: json[:name], message: json[:message])
    end

    def initialize(name:, message:)
      @name = name
      @message = message
    end
  end
end
