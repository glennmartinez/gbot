require 'binance'
require 'eventmachine'
require 'mongoid'
#  require '../../models/tradeperiods'
require 'require_all'
require 'date'
require_all 'models'


module Entry
  

  def self.LiveTrade(exchange, coins, period)

    case exchange
    when "binance"
     Binance.
    when "coinbase"
      "It's 6"
   
    else
     puts "No exchange config can be found for #{exchange}"
    end
  end

end
