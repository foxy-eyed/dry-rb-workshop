# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table(:inspections) do
      add_column :created_at, Time, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    alter_table(:inspections) do
      drop_column :created_at
    end
  end
end
