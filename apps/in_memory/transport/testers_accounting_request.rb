# frozen_string_literal: true

module InMemory
  module Transport
    class TestersAccountingRequest
      include Import[service: "contexts.testers_accounting.service"]

      def call
        puts "Handle testers accounting request..."
        sleep 0.5

        service.call

        puts "Done"
      end
    end
  end
end
