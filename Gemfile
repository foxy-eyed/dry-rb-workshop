# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.1.0"

# dependency management
gem "dry-system", "0.25"
gem "zeitwerk"

# load env variables
gem "dotenv"

group :test, :development do
  # TODO: add rubocop
end

group :test do
  gem "rspec"
  gem "simplecov", require: false
end
