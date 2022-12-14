# frozen_string_literal: true

require "dry/system/container"

require "zeitwerk"

class Container < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch("APP_ENV", :development).to_sym }
  use :zeitwerk

  # --- Dry-rb requirements ---
  require "dry-types"
  Dry::Types.load_extensions(:monads)

  require "dry-schema"
  Dry::Schema.load_extensions(:monads)

  require "dry-struct"

  require "dry/monads"
  require "dry/monads/do"

  configure do |config|
    # libraries
    config.component_dirs.add "lib" do |dir|
      dir.memoize = true
    end

    # business logic
    config.component_dirs.add "contexts" do |dir|
      dir.memoize = true

      dir.auto_register = proc do |component|
        !component.identifier.include?("entities") && !component.identifier.include?("types")
      end

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
