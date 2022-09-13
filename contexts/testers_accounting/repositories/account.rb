# frozen_string_literal: true

module TestersAccounting
  module Repositories
    class Account
      include Import[db: "persistence.db"]

      def find(id:)
        account = accounts.first(id: id)
        map_to_entity(account) if account
      end

      def reward!(id:, score:)
        accounts.where(id: id).update(score: score)
        find(id: id)
      end

      private

      def accounts
        @accounts ||= db[:accounts]
      end

      def map_to_entity(raw_attributes)
        TestersAccounting::Entities::Account.new(raw_attributes.compact)
      end
    end
  end
end
