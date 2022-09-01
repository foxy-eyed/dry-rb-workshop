# frozen_string_literal: true

module InMemory
  module Transport
    class ToyTestingRequest
      include Import[service: "contexts.toy_testing.service"]

      def call
        puts "Handle toy testing request..."
        sleep 0.5

        service.call

        puts "Done"
      end
    end
  end
end
