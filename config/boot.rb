# frozen_string_literal: true

require "dotenv"
require_relative "../system/container"

Dotenv.load(".env", ".env.#{ENV['APP_ENV']}")

Container.finalize!
