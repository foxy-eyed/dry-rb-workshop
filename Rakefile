# frozen_string_literal: true

require File.expand_path("config/boot", __dir__)

require "rake"

# rubocop
require "rubocop/rake_task"
RuboCop::RakeTask.new(:rubocop)

# load custom tasks
Rake.add_rakelib "lib/tasks"

task :environment do
  ENV["APP_ENV"] ||= "development"
end

task lint: %w[rubocop]
task fitness_functions: %w[fitness_functions:cross_context_calls]
