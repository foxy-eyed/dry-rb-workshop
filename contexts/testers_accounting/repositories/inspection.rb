# frozen_string_literal: true

module TestersAccounting
  module Repositories
    class Inspection
      include Import[db: "persistence.db"]

      def queue_for_account(account_id:)
        inspections.where(account_id: account_id, status: "pending").order(:created_at).map do |row|
          map_to_entity(row)
        end
      end

      def assign_to_account(account_id:, cat_toy_id:)
        inspection_id = inspections.insert(account_id: account_id, cat_toy_id: cat_toy_id)
        find(id: inspection_id)
      end

      def find(id:)
        map_to_entity(inspections.first(id: id))
      end

      private

      def inspections
        @inspections ||= db[:inspections]
      end

      def map_to_entity(raw_attributes)
        TestersAccounting::Entities::Inspection.new(raw_attributes.compact)
      end
    end
  end
end
