namespace :exchange  do
  task check_new_coins: :environment do
    loop do
      Exchange.all.each do |exchange|
        puts "check #{exchange.name} new coins"
        exchange.connector.service.update_exchange_coins({ exchange: exchange })
      end
    end
  end
end
