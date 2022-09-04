# frozen_string_literal: true

module ToyTesting
  module Repositories
    class Inspection
      include Import[db: "persistence.db"]

      def find(id:)
        inspection = inspections.first(id: id)
        map_to_entity(inspection) if inspection
      end

      def queue_size_for_account(account_id:)
        inspections.where(account_id: account_id, status: "pending").count
      end

      def queue_for_account(account_id:)
        inspections.where(account_id: account_id, status: "pending").order(:created_at).map do |row|
          map_to_entity(row)
        end
      end

      def assign_to_account!(account_id:, cat_toy_id:)
        inspection_id = inspections.insert(account_id: account_id, cat_toy_id: cat_toy_id)
        find(id: inspection_id)
      end

      def account_assigned?(account_id:, cat_toy_id:)
        inspections.where(account_id: account_id, cat_toy_id: cat_toy_id, status: "pending").count.positive?
      end

      def complete!(account_id:, cat_toy_id:, characteristics:)
        inspections.where(account_id: account_id, cat_toy_id: cat_toy_id)
                   .update(status: "ready", characteristics: characteristics.to_json)
        map_to_entity(inspections.where(account_id: account_id, cat_toy_id: cat_toy_id).first)
      end

      private

      def inspections
        @inspections ||= db[:inspections]
      end

      def map_to_entity(raw_attributes)
        ToyTesting::Entities::Inspection.new(prepare(raw_attributes))
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
