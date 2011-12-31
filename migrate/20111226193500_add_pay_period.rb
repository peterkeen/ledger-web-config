Sequel.migration do
  change do
    alter_table :ledger do
      add_column :pay_period, Integer
      add_index :pay_period
    end
  end
end
  
