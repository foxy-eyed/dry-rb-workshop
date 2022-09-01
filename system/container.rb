# frozen_string_literal: true

require "dry/system/container"

require "zeitwerk"

class Container < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch("APP_ENV", :development).to_sym }
  use :zeitwerk

  configure do |config|
    # libraries
    config.component_dirs.add "lib" do |dir|
      dir.memoize = true
    end

    # business logic
    config.component_dirs.add "contexts" do |dir|
      dir.memoize = true

      dir.namespaces.add "testers_accounting", key: "contexts.testers_accounting"
      dir.namespaces.add "toy_testing", key: "contexts.toy_testing"
    end

    # simple transport
    config.component_dirs.add "apps" do |dir|
      dir.memoize = true

      dir.namespaces.add "in_memory", key: "in_memory"
    end
  end
end

Import = Container.injector
