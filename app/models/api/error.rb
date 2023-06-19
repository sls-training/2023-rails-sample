# frozen_string_literal: true

module Api
  class Error < StandardError
    def self.from_json(json)
      msg = json.map do |error|
        "#{error[:name]}: #{error[:message]}"
      end
      Api::Error.new(msg:)
    end
  end
end
