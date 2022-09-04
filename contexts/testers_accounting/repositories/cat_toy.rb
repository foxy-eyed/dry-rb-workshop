# frozen_string_literal: true

module TestersAccounting
  module Repositories
    class CatToy
      include Import[db: "persistence.db"]

      def find(id:)
        cat_toy = cat_toys.first(id: id)
        map_to_entity(cat_toy) if cat_toy
      end

      def exists?(id:)
        !cat_toys.where(id: id).empty?
      end

      private

      def cat_toys
        @cat_toys ||= db[:cat_toys]
      end

      def map_to_entity(raw_attributes)
        TestersAccounting::Entities::CatToy.new(raw_attributes.compact)
      end
    end
  end
end