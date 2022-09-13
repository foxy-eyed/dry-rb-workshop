# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table(:accounts) do
      add_column :score, Integer, null: false, default: 0
    end
  end

  down do
    alter_table(:accounts) do
      drop_column :score
    end
  end
end
