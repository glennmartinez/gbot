require 'sinatra'
require 'require_all'
require 'mongoid'


require_all 'models'
Mongoid.load!("config/mongoid.yml")


get '/trades' do
    puts "FUCK U MAN"
    trades = Trades.distinct(:tradeid).to_json

    puts trades
    return trades
end

get '/trade' do


end


get '/*' do

    erb :index
end
