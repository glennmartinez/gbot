require 'binance'
require 'eventmachine'
require 'mongoid'
#  require '../../models/tradeperiods'
require 'require_all'
require 'date'
require_all 'models'


#https://github.com/craysiii/binance

module Binance

  $client = Binance::Client::REST.new
  $clientSocket = Binance::Client::WebSocket.new


  # TODO: fix static variables to come in from commamd
  def self.backFill(coins, period)
    puts "calling #{coins}"
    puts $client.ping
    cholo = $client.klines symbol: 'LTCBTC', interval: '1h', limit: 1000

    # puts cholo
     cholo.each do |i|
        puts i
        parseResponseAndSave("binance.LTCBTC", period, i)
     end

   
  end

  # TODO: fix the static variables to come from command args
  def self.Trade(coins, period)
    EM.run do
      # Create event handlers
    open    = proc { puts 'connected' }
    message = proc { |e| Binance.cholo(e.data)   }
    error   = proc { |e| puts e }
    close   = proc { puts 'closed' }

    # Bundle our event handlers into Hash
    methods = { open: open, message: message, error: error, close: close }
    
    # Pass a symbol and event handler Hash to connect and process events
    #  $clientSocket.agg_trade symbol: 'LTCBTC', methods: methods
     $clientSocket.kline symbol: coins, interval: period, methods: methods
   
    end 
  end

  def self.getTradesForPeriod(currentTrade, period, tradeMinutes )
    closetime =currentTrade.close_time - (tradeMinutes * 60000)
    lookback = closetime - ((period - 1) * tradeMinutes * 60000)
    savedTrades = TradePeriods.where(exchange_symbol: "binance.LTCBTC")
                  .and(:close_time.gte => lookback)
                  .and(:close_time.lte => closetime).order_by(:_id.asc)

    # puts "here are the trades and current close #{currentTrade.close_time}"
    
    return savedTrades
  end

  def self.cholo(data)
    puts "got the data fellas #{data}"
  end

  def self.simTrading(coin, days)

    currentTime = DateTime.now
    currentTimeUnix = currentTime.to_time.to_i * 1000

    startTime = currentTime - days
    startTimeUnix = startTime.to_time.to_i * 1000

    savedTrades = TradePeriods.where(exchange_symbol: coin, :close_time.gte => startTimeUnix).order_by(:close_time.asc)
    Engine.Trader(savedTrades, "test")

    # savedTrades.each do |t|
    #   puts t.close_time
    # end
  end


  def self.saveTrades()

    tradePeriod = {
      
       open_time: 1517184000000,
       open: 0.01657433300,
       high: 0.01659333000,
       low: 0.0160033000,
       close: 0.0161263300,
       volume: 73594.88000000,
       close_time: 1517270399999,
       quote_asset_vol: 1190.97217800,
       no_trades: 35382,
       taker_buy_base: 40792.38000000,
       take_buy_quote: 660.24999955,
       ignore: 232343.4433
    }

  TradePeriods.create(tradePeriod)
  end

  def self.parseResponseAndSave(exchange, period, event)
    tradePeriod = {
      exchange_symbol: exchange,
      period: period,
      open_time: event[0],
      open: event[1],
      high: event[2],
      low:  event[3],
      close: event[4],
      volume: event[5],
      close_time: event[6],
      quote_asset_vol: event[7],
      no_trades: event[8],
      taker_buy_base: event[9],
      take_buy_quote: event[10],
      ignore: event[11]
    }
    closeTime = event[6]
    # puts closetime  Bug.where(:created.gt => 1.year.ago, :project => params["project"]).sort(created: 1).entries.to_json,:exchange_symbol => "binance.LTCBTC",
     savedTrades = TradePeriods.where(:exchange_symbol => exchange, :close_time => closeTime).exists?
    #  puts = savedTrades
    
    if !savedTrades
      puts "Trade not found saving for #{closeTime}"
      TradePeriods.create(tradePeriod)

    end
  end

end

# savedTrades = TradePeriods.where(exchange_symbol: 'binance.LTCBTC')
