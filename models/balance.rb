


class Balance 

  include Mongoid::Document
  store_in collection: "trades"

  field :updated_time, type: String
  field :balance, type: Integer
  field :trade, type: Integer

  
  index({ key: 1 }, { unique: true, name: "update_time_index" })


end
