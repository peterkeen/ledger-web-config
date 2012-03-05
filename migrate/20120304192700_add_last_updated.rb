Sequel.migration do
  up do
    create_table(:update_history) do
      Time :updated_at
      Numeric :num_seconds
      String :checksum
    end
  end

  down do
    drop_table(:update_history)
  end
end
