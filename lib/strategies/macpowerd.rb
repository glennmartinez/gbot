require 'moving_average'


module MacPowerD


  def self.tradeLogic(tradeObject)
          # if  n1>n2 and strategy.opentrades<1 and confidence>dt and close>n2 and leadLine1>leadLine2 and open<LS and MACD>aMACD
    dt = 0.0010
    close_period = tradeObject[:close_period]
    open = tradeObject[:open] 
    close = tradeObject[:close]
    previousClose = tradeObject[:previousClose]
    n1 = tradeObject[:n1]
    n2 = tradeObject[:n2]
    confidence = tradeObject[:confidence]
    leadLine1 = tradeObject[:leadline1]
    leadLine2 = tradeObject[:leadline2]
    macD = tradeObject[:macD]
    macDa = tradeObject[:macDa]
    #===== puts tradeObject
    if (n1 > n2) && (confidence > dt) && (close > n2) && (leadLine1 > leadLine2) && (macD > 0)
      $sell += 1
      return "buy"
      #  and strategy.opentrades<ot and confidence<dt and close<n2 and leadLine1<leadLine2 and open>LS and MACD<aMACD
    elsif ( n1<n2) && (confidence<dt) && ( leadLine1<leadLine2) && (open > close) && (macD < 0)
      # && (close > n2) && (leadLine1 > leadLine2) && (macD > macDa)
      #   && macD > macDa
      $buy += 1
       puts "=====WE HAVE A SALE HERERE ======"
       return "sell"
    else 
      puts "None"
    end
    # puts "======== close period ======== #{close_period}"
          # tradeDetails = [{
          #   "close_period": t.close_time,
          #   "close": t.close,
          #   "previousClose": previousClose,
          #   "wmaShort": wmaShort,
          #   "wmaLong": wmaLong,
          #   "n1": n1,
          #   "n2": n2,
          #   "confidence": confidence,
          #   "leadline1": leadline1,
          #   "leadline2": leadline2,
          #   "macD": macD,
          #   "macDa": macDa
          # }]


  end

# TODO: remove current trade from calculation string or keep? maybe it's ok
  def self.MovingAverage(trade,period,minutes)

    closetime =trade.close_time
    lookback = closetime - (period * minutes * 60000)
    savedTrades = TradePeriods.where(exchange_symbol: "binance.LTCBTC")
                  .and(:close_time.gte => lookback)
                  .and(:close_time.lte => closetime).order_by(:_id.asc)

    closeTimeArray = []
    if savedTrades.count < period
      puts "no trades found"
    end
    shrunked = savedTrades.count
    # puts "GET ARRAY COUNT #{shrunked}"
    # reduced = savedTrades.distinct(:close_time)
    closetimes = []
    savedTrades.each do |t|
      # puts "id: #{t._id}  close time #{t.close_time} "
      closeTimeArray << t.close
    end
    # puts "doing this for #{period} and close #{trade.close}"
    # puts closeTimeArray

    sma = closeTimeArray.simple_moving_average
    ema = closeTimeArray.exponential_moving_average
    wma =  closeTimeArray.weighted_moving_average
    # puts closeTimeArray
    #  puts "simple: #{sma}  exponential: #{ema} weighted: #{wma}"

    return wma

  end
  # FIXME: Don't think we should be going back a period on this and then poping the array
  def self.WMACustom(trade, value, period, minutes)
    closetime =trade.close_time - (minutes * 60000)
    lookback = closetime - ((period - 1) * minutes * 60000)
    savedTrades = TradePeriods.where(exchange_symbol: "binance.LTCBTC")
                  .and(:close_time.gte => lookback)
                  .and(:close_time.lte => closetime).order_by(:_id.asc)

    tradeArray = []
    gboss = []
    savedTrades.each do |t|
    tradeArray << t.close
    end
    tradeArray << value 
    nm1 = tradeArray.weighted_moving_average
    return nm1

  end

  def self.WMACustomPrevious(trade, period, minutes)
    # take another period back to begin calc on previous trade
    closetime =trade.close_time - (minutes * 60000)
    lookback = closetime - (period * minutes * 60000)
    savedTrades = TradePeriods.where(exchange_symbol: "binance.LTCBTC")
                  .and(:close_time.gte => lookback)
                  .and(:close_time.lte => closetime).order_by(:_id.asc)

    tradeArray = []
    closes = []
    savedTrades.each do |t|
      tradeArray << t.close
      closes << t.close_time
    end

    #  puts "current close here #{trade.close_time}"
    # puts closes
     nm2 = tradeArray.weighted_moving_average
     return nm2

  end

  def self.WMAPreviousClose(trade, diff, period, minutes)
    closetime = trade.close_time - (minutes * 60000)
    lookback = closetime -  ((period - 1) * minutes * 60000)
    savedTrades = TradePeriods.where(exchange_symbol: "binance.LTCBTC")
                  .and(:close_time.gte => lookback)
                  .and(:close_time.lte => closetime).order_by(:_id.asc)

    times = []
    tradeArray = []
    savedTrades.each do |t|
      times << t.close_time
      tradeArray << t.close
    end
    tradeArray << diff
    nm2 = tradeArray.weighted_moving_average
    return nm2
  end

  def self.MacD(trade, currentClose)

    # MACD_Length = input(9)
    # MACD_fastLength = input(12)
    # MACD_slowLength = input(26)
    # MACD = ema(close, MACD_fastLength) - ema(close, MACD_slowLength)
    # aMACD = ema(MACD, MACD_Length)
    fastLengthTradeArray = Binance.getTradesForPeriod(trade, 12, 60)
    slowLengthTradeArray = Binance.getTradesForPeriod(trade, 26, 60)
    fastTradeArray = []
    slowTradeArray = []
    fastLengthTradeArray.each do |t|
      fastTradeArray << t.close
    end
    slowLengthTradeArray.each do |t|
      slowTradeArray << t.close
    end
    fastTradeArray << currentClose
    slowTradeArray << currentClose
    # puts "====fast trade #{fastTradeArray}"
    fastEma = fastTradeArray.exponential_moving_average.round(6)
    slowEMA = slowTradeArray.exponential_moving_average.round(6)

    cholo = (fastTradeArray.exponential_moving_average.round(6) - slowTradeArray.exponential_moving_average.round(6)).round(4)
    # puts "======FAST EMA #{fastEma} === SLOW EMA #{slowEMA} here's cholo = #{cholo}"

    macD = (fastEma - slowEMA).round(4)
    return macD
  end

  def self.MacDa(trade, macD)
    macDaTradeArray = Binance.getTradesForPeriod(trade, 9, 60)
    tradesArray = []
    macDaTradeArray.each do |t|
      tradesArray << t.close
    end

    tradesArray << macD
    macDa = tradesArray.exponential_moving_average

    return macDa.round(6)
  end

end

# TESTER PRESTER
          # if  n1>n2 and strategy.opentrades<1 and confidence>dt and close>n2 and leadLine1>leadLine2 and open<LS and MACD>aMACD
      #     dt = 0.0010

      # {:close_period=>1521061199999, :close=>0.019638, :previousClose=>0.01976, 
      #   :wmaShort=>0.019533127272727272, :wmaLong=>0.01929506084656085, 
      #   :n1=>0.019633873148148146, :n2=>0.019668957936507938, :confidence=>-0.00617408906882594,
      #    :leadline1=>0.019379499999999997, :leadline2=>0.019403499999999997,
      #     :macD=>0.00015776064711956264, :macDa=>0.015444960363699939}

      # first(n1)= no
      # 2nd(conf>dt) = yes
      # 3rd(close>n2) = no
      # 4th(leadline) = no
      # 5th(macd) = yes 

      # {:close_period=>1521061199999, :close=>0.019638, :previousClose=>0.01976,
      #    :wmaShort=>0.019533127272727272, :wmaLong=>0.01929506084656085, :n1=>0.019705939814814815,
      #     :n2=>0.019668957936507938, :confidence=>-0.00617408906882594, :leadline1=>0.019379499999999997,
      #      :leadline2=>0.019403499999999997, :macD=>0.00015776064711956264, :macDa=>0.015444960363699939}
    
          #  {:close_period=>1521061199999, :close=>0.019638, :previousClose=>0.01976,
          #    :wmaShort=>0.019533127272727272, :wmaLong=>0.01929506084656085,
          #     :n1=>0.019706, :n2=>0.019691, :confidence=>-0.00617408906882594, 
          #     :leadline1=>0.019379499999999997, :leadline2=>0.019403499999999997,
          #      :macD=>0.00015776064711956264,:macDa=>0.015444960363699939}
#           new trade for close 1521061199999
# {:close_period=>1521061199999, :close=>0.019638, :previousClose=>0.01976,
#    :wmaShort=>0.019533127272727272, :wmaLong=>0.01929506084656085, 
#    :n1=>0.019734, :n2=>0.019716, :confidence=>-0.00617408906882594, 
#    :leadline1=>0.019379499999999997, :leadline2=>0.019403499999999997, 
#    :macD=>0.00015776064711956264,:macDa=>0.015444960363699939}
# {:close_period=>1521061199999, :close=>0.019638, :previousClose=>0.01976,
#    :wmaShort=>0.019533127272727272, :wmaLong=>0.01929506084656085,
#     :n1=>0.019734, :n2=>0.019716, :confidence=>-0.00617408906882594,
#      :leadline1=>0.019379499999999997, :leadline2=>0.019403499999999997,
#       :macD=>0.00015776064711956264,:macDa=>0.015444960363699939}

# {:close_period=>1521061199999, :close=>0.019638, :previousClose=>0.01976,
#    :wmaShort=>0.019533127272727272, :wmaLong=>0.01929506084656085,
#     :n1=>0.019734, :n2=>0.019691, :confidence=>-0.00617408906882594, 
#     :leadline1=>0.019379499999999997, :leadline2=>0.019403499999999997, 
#     :macD=>0.00015776064711956264,:macDa=>0.015444960363699939}

#   first(n1)= yes
#       2nd(conf>dt) = yes
#       3rd(close>n2) = yes
#       4th(leadline) = no
#       5th(macd) = yes 
# new trade for close 1521514799999
# {:close_period=>1521514799999, :close=>0.018768, 
#   :previousClose=>0.018707, :wmaShort=>0.018708363636363638,
#    :wmaLong=>0.018717044973544976, :n1=>0.018717,
#     :n2=>0.018705, :confidence=>0.0032608114609503688, 
#     :leadline1=>0.018716999999999998, :leadline2=>0.019125,
#      :macD=>4.851472601093837e-06, :macDa=>0.014770395552236025}

#  first(n1)= yes
#  2nd(conf>dt) = yes
#  3rd(close>n2) = yes
#  4th(leadline) = yes
#  5th(macd) = yes 
# new trade for close 1521604799999
# {:close_period=>1521604799999, :close=>0.019178, :previousClose=>0.019063,
#    :wmaShort=>0.019034000000000002, :wmaLong=>0.018964145502645503, :n1=>0.019045,
#     :n2=>0.019016, :confidence=>0.006032628652363244, :leadline1=>0.018976,
#      :leadline2=>0.0188725, :macD=>7.966205273420707e-05, :macDa=>0.01503217829680589}