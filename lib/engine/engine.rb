require 'json'

module Engine


  def self.Trader(trades, test)

    $currentCalculation = []
    $buy = 0
    $sell = 0

    trades.each do |t|
       wmaShort = MacPowerD.MovingAverage(t,9,60)
       wmaLong =  MacPowerD.MovingAverage(t,26,60)
       dt = 0.0010
       n1 = Engine.n1(t)
       n2 = Engine.n2(t)
       close = t[:close]
       macD = MacPowerD.MacD(t, close)
       macDa = MacPowerD.MacDa(t, macD)

      previousClose = 0

      # TODO: try calculating previous run with the below logic to see if it gets the same
      # next if currentCalculation.empty?
      if !$currentCalculation.empty?
        "hitting it"
        lastTrade = $currentCalculation.last
        previousClose = lastTrade[0][:close]
      end 
      confidence = Engine.calcConfidence(close, previousClose)
      leadline1 = Engine.leadlines(t,9, 60)
      leadline2 = Engine.leadlines2(t,52, 60)
      puts "new trade for close #{t.close_time}"


      # TODO: Fix this hash and do it properly like in pipeline method
      tradeDetails = {}
       tradeDetails = {
        "close_period": t.close_time,
        "open": t.open,
        "close": t.close,
        "previousClose": previousClose,
        "wmaShort": wmaShort,
        "wmaLong": wmaLong,
        "n1": n1,
        "n2": n2,
        "confidence": confidence,
        "leadline1": leadline1,
        "leadline2": leadline2,
        "macD": macD,
        "macDa": macDa
      }
        $currentCalculation << [tradeDetails]
      #  puts $currentCalculation
      
      tradeAction = MacPowerD.tradeLogic(tradeDetails)

      case tradeAction
      when "buy"
        puts "buying"
        Engine.actionBuy(tradeDetails)
      when "sell"
        # puts "selling"
      else
        # puts "Holding no action was triggered"
      end

    end
      # $puts $currentCalculation.to_json
      puts "buy count #{$buy}"
      puts "sell count #{$sell}"

  end

  def self.actionBuy(tradeDetails)
    currentTrades = Trades.asc(:time).last
    puts currentTrades
    if currentTrades.nil? || currentTrades.empty?
     puts "puts EMPTTTYYYYYYYY============"
    elsif currentTrades.status == "bought"

      puts "current trade active"
    else
      tradeDetails
      field :exchange_symbol, type: String
      field :period, type: Integer
      field :price, type: Float
      field :volume, type: Float
      field :time, type: Integer
      field :amount, type: Integer
      field :profit, type: Integer
      field :balance, type: Integer
      field :status, type: String 
      Trades.create()

    end
  end


  def self.n1(trade)
    sqn = 3.74
    n2ma = (2 * MacPowerD.MovingAverage(trade,7,60)).round(6)
    nma = (MacPowerD.MovingAverage(trade,14, 60)).round(6)
    diff = (n2ma - nma).round(6)
    n1 = (MacPowerD.WMACustom(trade, diff, sqn, 60)).round(6)

    tradeDetails = [{
        "sqn": sqn,
        "n2ma": n2ma,
        "nma": nma,
        "diff": diff,
        "n1": n1
      }]
    return n1
  end


# TODO:fix this as n2ma and nma should be calculated on previous period
  def self.n2(trade)
    sqn = 4
    n2ma = (2 * MacPowerD.WMACustomPrevious(trade,7,60)).round(6)
    nma = (MacPowerD.WMACustomPrevious(trade,14, 60)).round(6)
    diff = (n2ma - nma).round(6)
    # n2 = MacPowerD.WMACustomPrevious(trade, diff, sqn, 60)
    n2 = (MacPowerD.WMAPreviousClose(trade, diff, sqn, 60)).round(6)
    # MacPowerD.WMACustomPrevious(trade,diff, sqn, 60)
    tradeDetails = [{
      "sqn": sqn,
      "n2ma": n2ma,
      "nma": nma,
      "diff": diff,
      "n1": n2
    }]
    # puts "trade details"
    # puts tradeDetails
    return n2
  end

  def self.calcConfidence(close, previousClose)
    # confidence=(security(tickerid, 'D', close)-security(tickerid, 'D', close[1]))/security(tickerid, 'D', close[1])
    if previousClose > 0
      confidenveValue = (close - previousClose) / previousClose

    else
      confidenveValue = 0
    end

    return confidenveValue
  end

  def self.leadlines(currentTrade, period, timeframe)

    tradesListConversionPeriod = Binance.getTradesForPeriod(currentTrade, 9, timeframe)
    conversionPeriodArray = Engine.minMaxCalculator(tradesListConversionPeriod)
    conversionPeriodMin = conversionPeriodArray[:min]
    conversionPeriodMax = conversionPeriodArray[:max]

    tradesListBaselinePeriod = Binance.getTradesForPeriod(currentTrade, 26, 60)
    baselinePeriodArray = Engine.minMaxCalculator(tradesListBaselinePeriod)
    baselinePeriodMin = baselinePeriodArray[:min]
    baselinePeriodMax = baselinePeriodArray[:max]

    conversionLine = (conversionPeriodMin + conversionPeriodMax) / 2
    baseLine = (baselinePeriodMin + baselinePeriodMax) / 2
    leadline = (conversionLine + baseLine) / 2

    return leadline
    
  end

  def self.leadlines2(currentTrade, period, timeframe)
    tradesListConversionPeriod = Binance.getTradesForPeriod(currentTrade, 52, timeframe)
    conversionPeriodArray = Engine.minMaxCalculator(tradesListConversionPeriod)
    conversionPeriodMin = conversionPeriodArray[:min]
    conversionPeriodMax = conversionPeriodArray[:max]

    conversionLine = (conversionPeriodMin + conversionPeriodMax) / 2

    return conversionLine

  end

  def self.minMaxCalculator(trades)
    lowValues = []
    highValues = []

    trades.each do |t|
      lowValues << t.low
      highValues << t.high
    end

    lowestPeriodValue = lowValues.min
    highestPeriodValue = highValues.max

    result = {
      "min": lowestPeriodValue,
      "max": highestPeriodValue
    }

    return result
  end


# conversionPeriods = input(9, minval=1, title="Conversion Line Periods")
#   basePeriods = input(26, minval=1, title="Base Line Periods")
# laggingSpan2Periods = input(52, minval=1, title="Lagging Span 2 Periods")
# displacement = input(26, minval=1, title="Displacement")
# donchian(len) => avg(lowest(len), highest(len))
# conversionLine = donchian(conversionPeriods)
# baseLine = donchian(basePeriods)
# leadLine1 = avg(conversionLine, baseLine)
# leadLine2 = donchian(laggingSpan2Periods)
  # // longCondition = n1>n2 and strategy.opentrades<ot and confidence>dt and close>n2 and leadLine1>leadLine2 and open<LS and MACD>aMACD

  # // n1=wma(diff,sqn)
  # //     sqn=round(sqrt(keh))
  # //         sqn=3.74 (round = 4?)
  # //     diff=n2ma-nma
  # //         n2ma=2*wma(close,round(keh/2))
  # //         * 2*wma(close-price,round(14/2))
  # //         nma=wma(close,keh)
  # //             *wma(close-price, 14)
#   // n2=wma(diff1,sqn)
# //     diff1=n2ma1-nma1
# //         n2ma1=2*wma(close[1],round(keh/2))
# //         nma1=wma(close[1],keh)

end







# logic

# TODO: simulation/trade, daysback, strategy, exchange_coins, period
# TODO: get and save data for tradeperios for days back
# TODO: call Strategy Type
# TODO: pass list of saved trades
# TODO: iterate through first (oldest)







