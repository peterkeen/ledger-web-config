require 'digest/sha1'

LedgerWeb::Config.new do |config|
  config.set :database_url, "postgres://localhost/ledger2"
  config.set :index_report, :dashboard

  config.add_hook :before_insert_row do |row|
    reference_date = Date.new(2011, 4, 15)

    xtn_date = Date.strptime(row[:xtn_date], "%Y/%m/%d")

    row[:pay_period] = 2

    if xtn_date >= reference_date then
      if xtn_date.day <= 15
        row[:pay_period] = 1
      end
    else
      if xtn_date.day <= 6 or xtn_date.day >= 22 then
        row[:pay_period] = 1
      end
    end

    row

  end

  config.set :price_lookup_skip_symbols, ['$', 's']

  config.add_hook :after_load do |db|
    LedgerWeb::Database.load_prices
  end

  config.add_hook :before_load do |db|
    config.set :load_start, Time.now.utc
    d = Digest::SHA1.new
    puts "Calculating checksum"

    d.file("/Users/peter/ledger.txt")

    config.set :checksum, d.hexdigest()
    puts "Done calculating checksum"
  end

  config.add_hook :after_load do |db|
    puts "Inserting update record"
    now = Time.now.utc
    start = config.get :load_start
    checksum = config.get :checksum

    puts "Doing insert"
    db[:update_history].insert(
      :updated_at => now,
      :num_seconds => now - start,
      :checksum => checksum
    )
    puts "Done Inserting Update Record"
  end
end
