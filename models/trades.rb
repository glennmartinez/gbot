
class Trades 

  include Mongoid::Document
  store_in collection: "trades"

  field :exchange_symbol, type: String
  field :period, type: Integer
  field :price, type: Float
  field :volume, type: Float
  field :time, type: Integer
  field :amount, type: Integer
  field :profit, type: Integer
  field :balance, type: Integer
  field :status, type: String 
  
  index({ key: 1 }, { unique: true, name: "time_index" })


end
