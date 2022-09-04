# frozen_string_literal: true

module ToyTesting
  module Repositories
    class Account
      include Import[db: "persistence.db"]

      def find(id:)
        account = accounts.first(id: id)
        map_to_entity(account) if account
      end

      def exists?(id:)
        !accounts.where(id: id).empty?
      end

      private

      def accounts
        @accounts ||= db[:accounts]
      end

      def map_to_entity(raw_attributes)
        ToyTesting::Entities::Account.new(raw_attributes.compact)
      end
    end
  end
end
