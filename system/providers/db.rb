# frozen_string_literal: true

Container.register_provider(:db) do
  prepare do
    require "sequel"

    Sequel.extension :migration
  end

  start do
    db = Sequel.postgres(
      host: ENV.fetch("POSTGRES_HOST", "localhost"),
      user: ENV["POSTGRES_USER"],
      password: ENV["POSTGRES_PASSWORD"],
      database: ENV.fetch("POSTGRES_DB", "dry_rb_workshop_#{ENV['APP_ENV']}")
    )

    register("persistence.db", db)
  end
end
