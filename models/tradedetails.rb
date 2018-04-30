
class TradeDetails

    include Mongoid::Document
    store_in collection: "tradedetails"
  
    field :tradeid
    field :exchange_symbol, type: String
    field :price, type: Float
    field :volume, type: Integer
    field :time, type: Integer
    field :amount, type: Integer
    field :profit, type: Integer
    field :balance, type: Integer
    field :status, type: String 
    field :trade_details, type: String
    
    index({ key: 1 }, { unique: true, name: "time_index" })
  
  
  end
  