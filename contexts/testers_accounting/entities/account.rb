# frozen_string_literal: true

module TestersAccounting
  module Entities
    class Account < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, TestersAccounting::Types::Integer
      attribute :name, TestersAccounting::Types::AccountName
      attribute :email, TestersAccounting::Types::AccountEmail
    end
  end
end
