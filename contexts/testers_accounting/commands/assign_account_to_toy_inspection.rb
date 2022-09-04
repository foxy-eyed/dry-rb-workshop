# frozen_string_literal: true

module TestersAccounting
  module Commands
    class AssignAccountToToyInspection
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      include Import[
        account_repo: "contexts.testers_accounting.repositories.account",
        cat_toy_repo: "contexts.testers_accounting.repositories.cat_toy",
        inspection_repo: "contexts.testers_accounting.repositories.inspection",
      ]

      MAX_INSPECTION_QUEUE_SIZE = 3

      def call(account_id:, cat_toy_id:)
        cat_toy = yield find_toy(cat_toy_id)
        account = yield find_account(account_id)

        assign_to_inspection(account, cat_toy)
      end

      private

      def find_toy(toy_id)
        toy = cat_toy_repo.find(id: toy_id)
        return Failure([:cat_toy_not_found, { cat_toy_id: toy_id }]) unless toy

        Success(toy)
      end

      def find_account(account_id)
        account = account_repo.find(id: account_id)
        return Failure([:account_not_found, { account_id: account_id }]) unless account

        Success(account)
      end

      def assign_to_inspection(account, cat_toy)
        if inspection_repo.queue_size_for_account(account_id: account.id) >= MAX_INSPECTION_QUEUE_SIZE
          return Failure([:account_queue_overflow, { account: account, max_size: MAX_INSPECTION_QUEUE_SIZE }])
        end

        inspection = inspection_repo.assign_to_account!(account_id: account.id, cat_toy_id: cat_toy.id)
        Success(inspection)
      end
    end
  end
end
