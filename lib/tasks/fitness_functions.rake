# frozen_string_literal: true

Dir[File.expand_path("../../fitness_functions/**/*.rb", __dir__)].each { |f| require f }

DEPENDENCY_WHITE_LIST = {
  "apps/in_memory/transport/testers_accounting_request.rb" => %w[contexts.testers_accounting.service],
  "apps/in_memory/transport/toy_testing_request.rb" => %w[contexts.toy_testing.service],
  "contexts/testers_accounting/commands/reward_account.rb" => %w[
    contexts.testers_accounting.repositories.account
    contexts.testers_accounting.repositories.inspection
  ],
  "contexts/toy_testing/commands/assign_account_to_toy_inspection.rb" => %w[
    contexts.toy_testing.repositories.account
    contexts.toy_testing.repositories.cat_toy
    contexts.toy_testing.repositories.inspection
  ],
  "contexts/toy_testing/commands/complete_inspection.rb" => %w[
    contexts.toy_testing.repositories.account
    contexts.toy_testing.repositories.cat_toy
    contexts.toy_testing.repositories.inspection
  ],
  "contexts/toy_testing/queries/pending_inspections_for_account.rb" => %w[
    contexts.toy_testing.repositories.account
    contexts.toy_testing.repositories.cat_toy
    contexts.toy_testing.repositories.inspection
  ],
  "contexts/testers_accounting/repositories/account.rb" => %w[persistence.db],
  "contexts/testers_accounting/repositories/inspection.rb" => %w[persistence.db],
  "contexts/toy_testing/repositories/account.rb" => %w[persistence.db],
  "contexts/toy_testing/repositories/cat_toy.rb" => %w[persistence.db],
  "contexts/toy_testing/repositories/inspection.rb" => %w[persistence.db]
}.freeze

DELIMITER = "*" * 40

namespace :fitness_functions do
  task :cross_context_calls do
    DEPENDENCY_WHITE_LIST.each do |file_path, white_list|
      FitnessFunctions::CrossContextCallsChecker.new.call(file_path, whitelist: white_list)
      puts DELIMITER
    end
  end
end
