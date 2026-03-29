# frozen_string_literal: true

module Types
  class JsonType < Types::BaseScalar
    description "Arbitrary JSON data"

    def self.coerce_input(value, _ctx)
      case value
      when String then JSON.parse(value)
      when Hash, Array then value
      else raise GraphQL::CoercionError, "#{value.inspect} is not valid JSON"
      end
    end

    def self.coerce_result(value, _ctx)
      value
    end
  end
end
