# frozen_string_literal: true

module ToyTesting
  module Entities
    class Inspection < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, ToyTesting::Types::Integer
      attribute :account_id, ToyTesting::Types::Integer
      attribute :cat_toy_id, ToyTesting::Types::Integer
      attribute :status, ToyTesting::Types::InspectionStatus
      attribute? :characteristics, ToyTesting::Types::InspectionCharacteristics
    end
  end
end
