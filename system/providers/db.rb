# frozen_string_literal: true

Container.register_provider(:db) do
  prepare do
    require "sequel"

    Sequel.extension :migration
  end

  start do
    db = Sequel.postgres(
      host: ENV.fetch("DB_HOST", "localhost"),
      user: ENV["DB_USER"],
      password: ENV["DB_PASSWORD"],
      database: ENV.fetch("DB_NAME", "dry_rb_workshop_#{ENV['APP_ENV']}")
    )

    register("persistence.db", db)
  end
end
