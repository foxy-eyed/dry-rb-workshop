# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.1.0"

# dependency management
gem "dry-system", "0.25"
gem "zeitwerk"

# load env variables
gem "dotenv"

# persistence layer
gem "dry-schema", "1.1"
gem "dry-struct", "1.0"
gem "dry-types", "1.5"
gem "pg"
gem "sequel"

# fitness functions
gem "parser"

gem "rake"

group :test, :development do
  gem "rubocop", require: false
  gem "rubocop-rspec"
end

group :test do
  gem "rspec"
  gem "simplecov", require: false
end
