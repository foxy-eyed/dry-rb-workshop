# frozen_string_literal: true

module TestersAccounting
  module Entities
    class CatToy < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, TestersAccounting::Types::Integer
      attribute :name, TestersAccounting::Types::CatToyName
    end
  end
end
