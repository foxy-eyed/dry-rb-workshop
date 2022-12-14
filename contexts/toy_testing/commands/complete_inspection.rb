# frozen_string_literal: true

module ToyTesting
  module Commands
    class CompleteInspection
      include Dry::Monads[:result, :try]
      include Dry::Monads::Do.for(:call)

      include Import[
        account_repo: "contexts.toy_testing.repositories.account",
        cat_toy_repo: "contexts.toy_testing.repositories.cat_toy",
        inspection_repo: "contexts.toy_testing.repositories.inspection",
      ]

      InspectionSchemaValidator = Dry::Schema.Params do
        required(:account_id).value(ToyTesting::Types::Id)
        required(:cat_toy_id).value(ToyTesting::Types::Id)
        required(:characteristics).value(ToyTesting::Types::InspectionCharacteristics)
      end

      def call(payload)
        data = yield validate_inspection(payload)
        account = yield find_account(data[:account_id])
        toy = yield find_toy(data[:cat_toy_id])

        complete_inspection!(account, toy, data[:characteristics])
      end

      private

      def validate_inspection(payload)
        InspectionSchemaValidator.call(**payload).to_monad
      end

      def find_toy(toy_id)
        toy = cat_toy_repo.find(id: toy_id)
        return Failure([:cat_toy_not_found, { cat_toy_id: toy_id }]) unless toy
        return Failure([:cat_toy_tested, { cat_toy_id: toy_id }]) if cat_toy_repo.tested?(id: toy_id)

        Success(toy)
      end

      def find_account(account_id)
        account = account_repo.find(id: account_id)
        return Failure([:account_not_found, { account_id: account_id }]) unless account

        Success(account)
      end

      def complete_inspection!(account, toy, characteristics)
        if inspection_repo.account_assigned?(account_id: account.id, cat_toy_id: toy.id)
          Try[Sequel::Error] do
            inspection_repo.complete!(account_id: account.id, cat_toy_id: toy.id, characteristics: characteristics)
          end.to_result.or(
            Failure([:db_error])
          )
        else
          Failure([:account_not_assigned_to_toy, { account_id: account_id, cat_toy_id: toy_id }])
        end
      end
    end
  end
end
