# gbot


Crypto bot

### Install Deps

``` 
ruby use 2.2.3
bundle install


```

### To Run
```
bundle exec bin/gbot.rb [command]

bundle exec bin/gbot.rb sim
```

## To Load Trades from Binance
Make sure to have mongod running in the background
```
bundle exec bin/gbot.rb backfill

```

### How it works

The backfill command runs Binance.backfill with the coin combination and period of the trade, ie: 60minute trading periods

This will fetch x number of trades and save them to the mongo db database.

#### The sim command

This command uses Binance.simTrading with the coin combination and number of days to simulate going back
This calls Binance.simTrading method

This calls the db and returns an array of trades which are then passed to the 
```
Engine.Trader function
```

This function iterate over each trade starting from the oldest.

From here it starts performing the technical analysis. so for every trade it goes back x number of trades to calculate the ema ect.

I also use MacPowerD class to calculate some tech analysis here.

Then it goes to the MacPowerd.tradeLogic which then decides if its a buy or sell as per the tradingview script's logic.
this returns a buy and sell back to engine class which then it saves this along with balance and profit into a 'trade' object.