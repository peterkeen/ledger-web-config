Sequel.migration do
  up do
    create_or_replace_view :expenses, "select * from ledger where account ~ '^Expenses'"
    create_or_replace_view :income, "select * from ledger where account ~ '^Income'"
    create_or_replace_view :assets, "select * from ledger where account ~ '^Assets'"
    create_or_replace_view :liabilities, "select * from ledger where account ~ '^Liabilities'"
    create_or_replace_view :checking, "select * from ledger where account ~ '^Assets:.*:Checking'"
  end
  down do
    drop_view :expenses
    drop_view :income
    drop_view :assets
    drop_view :liabilities
    drop_view :checking
  end
end
