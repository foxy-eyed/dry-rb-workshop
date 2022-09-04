# frozen_string_literal: true

module TestersAccounting
  module Queries
    class PendingInspectionsForAccount
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      include Import[
        account_repo: "contexts.testers_accounting.repositories.account",
        inspection_repo: "contexts.testers_accounting.repositories.inspection",
      ]

      def call(account_id:)
        account = yield find_account(account_id)

        fetch_pending_inspections(account)
      end

      private

      def find_account(account_id)
        account = account_repo.find(id: account_id)
        return Failure([:account_not_found, { account_id: account_id }]) unless account

        Success(account)
      end

      def fetch_pending_inspections(account)
        inspections = inspection_repo.queue_for_account(account_id: account.id)

        Success(inspections)
      end
    end
  end
end
