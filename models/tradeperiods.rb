
class TradePeriods

  include Mongoid::Document
  store_in collection: "tradeperiods"

  field :exchange_symbol, type: String
  field :period, type: Integer
  field :open_time, type: Integer
  field :open, type: Float
  field :high, type: Float
  field :low, type: Float
  field :close, type: Float
  field :volume, type: Float
  field :close_time, type: Integer
  field :quote_asset_vol, type: Integer
  field :no_trades, type: Integer
  field :taker_buy_base, type: Integer
  field :take_buy_quote, type: Integer
  field :ignore, type: Integer

  index({ key: 1 }, { unique: true, name: "open_time_index" })


end


# 1517184000000
# 0.01657400
# 0.01659000
# 0.01600000
# 0.01612600
# 73594.88000000
# 1517270399999
# 1190.97217800
# 35382
# 40792.38000000
# 660.24999955
# 0

# 1499040000000,      // Open time
# "0.01634790",       // Open
# "0.80000000",       // High
# "0.01575800",       // Low
# "0.01577100",       // Close
# "148976.11427815",  // Volume
# 1499644799999,      // Close time
# "2434.19055334",    // Quote asset volume
# 308,                // Number of trades
# "1756.87402397",    // Taker buy base asset volume
# "28.46694368",      // Taker buy quote asset volume
# "17928899.62484339" // Ignore