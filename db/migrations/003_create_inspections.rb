# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:inspections) do
      primary_key :id
      foreign_key :account_id, :accounts, type: Integer
      foreign_key :cat_toy_id, :cat_toys, type: Integer
      String :status, null: false, default: "pending"
      String :characteristics

      index %i[account_id cat_toy_id], unique: true
    end
  end

  down do
    drop_table(:inspections)
  end
end
