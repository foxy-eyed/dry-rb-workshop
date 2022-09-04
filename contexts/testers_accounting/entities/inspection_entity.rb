# frozen_string_literal: true

module TestersAccounting
  module Entities
    class InspectionEntity < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, TestersAccounting::Types::Integer
      attribute :account_id, TestersAccounting::Types::Integer
      attribute :cat_toy_id, TestersAccounting::Types::Integer
      attribute :status, TestersAccounting::Types::InspectionStatus
      attribute? :characteristics, TestersAccounting::Types::InspectionCharacteristics
    end
  end
end
