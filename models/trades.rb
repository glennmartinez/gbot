
class Trades 

  include Mongoid::Document
  store_in collection: "trades"

  field :tradeid
  field :exchange_symbol, type: String
  field :time, type: Integer
  field :timerange, type: Integer 
  
  index({ key: 1 }, { unique: true, name: "time_index" })


end
