# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:cat_toys) do
      primary_key :id, type: :Bignum
      String :name, null: false
    end
  end

  down do
    drop_table(:cat_toys)
  end
end
