# frozen_string_literal: true

module TestersAccounting
  module Entities
    class Account < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, TestersAccounting::Types::Id
      attribute :blocked, TestersAccounting::Types::Bool
      attribute :score, TestersAccounting::Types::Integer

      def blocked?
        blocked
      end
    end
  end
end
