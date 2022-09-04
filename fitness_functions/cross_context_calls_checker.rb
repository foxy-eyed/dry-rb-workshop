# frozen_string_literal: true

module FitnessFunctions
  class CrossContextCallsChecker
    def call(file_path, whitelist: [])
      di_imports = parser.call(file_path)

      puts "Checking: '#{file_path}'"
      puts "Dependencies for file: #{di_imports}"

      di_imports.each do |dependency|
        next if dependency.start_with?(*whitelist)

        raise "Invalid dependency '#{dependency}' for '#{file_path}'"
      end
    end

    private

    def parser
      @parser ||= FitnessFunctions::Support::FileDependenciesParser.new
    end
  end
end
