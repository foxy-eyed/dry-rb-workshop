# frozen_string_literal: true

Dir[File.expand_path("../../fitness_functions/**/*.rb", __dir__)].each { |f| require f }

DEPENDENCY_WHITE_LIST = {
  "apps/in_memory/transport/testers_accounting_request.rb" => %w[contexts.testers_accounting.service],
  "apps/in_memory/transport/toy_testing_request.rb" => %w[contexts.toy_testing.service],
  "contexts/testers_accounting/service.rb" => [],
  "contexts/toy_testing/service.rb" => []
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
