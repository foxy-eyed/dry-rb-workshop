# frozen_string_literal: true

module TestersAccounting
  module Repositories
    class Inspection
      include Import[db: "persistence.db"]

      def completed_by_account(account_id:)
        db[:inspections].where(account_id: account_id, status: "ready").map do |row|
          map_to_entity(row)
        end
      end

      private

      def map_to_entity(raw_attributes)
        TestersAccounting::Entities::Inspection.new(prepare(raw_attributes))
      end

      def prepare(row)
        characteristics_json = row.delete(:characteristics)
        characteristics = if characteristics_json
                            JSON.parse(characteristics_json).map { |item| item.transform_keys(&:to_sym) }
                          end
        row.merge(characteristics: characteristics).compact
      end
    end
  end
end
