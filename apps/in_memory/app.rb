# frozen_string_literal: true

require_relative "../../config/environment"
require_relative "../../config/boot"

puts "Loading container:"
puts "container: #{Container}"
puts "container keys: #{Container.keys}"

puts "*" * 40
Container["in_memory.transport.toy_testing_request"].call

puts "*" * 40
Container["in_memory.transport.testers_accounting_request"].call
