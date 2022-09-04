# frozen_string_literal: true

module TestersAccounting
  module Commands
    class RewardAccount
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      include Import[
        account_repo: "contexts.testers_accounting.repositories.account",
        inspection_repo: "contexts.testers_accounting.repositories.inspection",
      ]

      PER_INSPECTION_REWARD = 1_000

      def call(account_id:)
        account = yield find_account(account_id)
        score = yield collect_completed_inspections(account)

        reward_account!(account, score)
      end

      private

      def find_account(account_id)
        account = account_repo.find(id: account_id)
        return Failure([:account_not_found, { account_id: account_id }]) unless account
        return Failure([:account_is_blocked, { account_id: account_id }]) if account.blocked?

        Success(account)
      end

      def collect_completed_inspections(account)
        inspections = inspection_repo.completed_by_account(account_id: account.id)
        if inspections.any?(&:discarded?)
          Failure([:account_has_bad_tests], { account: account })
        else
          score = inspections.count * PER_INSPECTION_REWARD
          Success(score)
        end
      end

      def reward_account!(account, score)
        account_repo.reward!(id: account.id, score: score)
      end
    end
  end
end
