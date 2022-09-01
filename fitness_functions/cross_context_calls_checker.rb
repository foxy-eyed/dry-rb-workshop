# frozen_string_literal: true

require "parser/current"
require_relative "../config/boot"

module FitnessFunctions
  class CrossContextCallsChecker
    include Import[parser: "fitness_functions.file_dependencies_parser"]

    def call(file_path, whitelist: [])
      di_imports = parser.call(file_path)

      puts "Checking: '#{file_path}'"
      puts "Dependencies for file: #{di_imports}"

      di_imports.each do |dependency|
        next if dependency.start_with?(*whitelist)

        raise "Invalid dependency '#{dependency}' for '#{file_path}'"
      end
    end
  end
end

# =========================================

WHITE_LIST = {
  "apps/in_memory/transport/testers_accounting_request.rb" => %w[contexts.testers_accounting.service],
  "apps/in_memory/transport/toy_testing_request.rb" => %w[contexts.toy_testing.service],
  "contexts/testers_accounting/service.rb" => [],
  "contexts/toy_testing/service.rb" => []
}.freeze
DELIMITER = "*" * 40

WHITE_LIST.each do |file_path, white_list|
  FitnessFunctions::CrossContextCallsChecker.new.call(file_path, whitelist: white_list)
  puts DELIMITER
end
