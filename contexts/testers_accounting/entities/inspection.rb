# frozen_string_literal: true

module TestersAccounting
  module Entities
    class Inspection < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, TestersAccounting::Types::Id
      attribute :account_id, TestersAccounting::Types::Id
      attribute :cat_toy_id, TestersAccounting::Types::Id
      attribute :status, TestersAccounting::Types::InspectionStatus
      attribute? :characteristics, TestersAccounting::Types::InspectionCharacteristics

      def discarded?
        status == "ready" && characteristics.nil?
      end
    end
  end
end
