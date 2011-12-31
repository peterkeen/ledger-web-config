LedgerWeb::Config.new do |config|
  config.set :database_url, "postgres://localhost/ledger2"
  config.set :index_report, :dashboard

  config.add_hook :before_insert_row do |row|
    reference_date = Date.new(2011, 4, 15)

    xtn_date = Date.strptime(row[:xtn_date], "%Y/%m/%d")

    row[:pay_period] = 2

    if xtn_date >= reference_date then
      if xtn_date.day < 14
        row[:pay_period] = 1
      end
    else
      if xtn_date.day <= 6 or xtn_date.day >= 22 then
        row[:pay_period] = 1
      end
    end

  end
end
