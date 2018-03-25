# // closelong = n1<n2 and close<n2 and confidence<dt or strategy.openprofit<SL or strategy.openprofit>TP
# // shortCondition = n1<n2 and strategy.opentrades<ot and confidence<dt and close<n2 and leadLine1<leadLine2 and open>LS and MACD<aMACD
# // closeshort = n1>n2 and close>n2 and confidence>dt or strategy.openprofit<SL or strategy.openprofit>TP


# // n1=wma(diff,sqn)
# //     sqn=round(sqrt(keh))
# //         sqn=3.74 (round = 4?)
# //     diff=n2ma-nma
# //         n2ma=2*wma(close,round(keh/2))
# //         * 2*wma(close-price,round(14/2))
# //         nma=wma(close,keh)
# //             *wma(close-price, 14)

# // n2=wma(diff1,sqn)
# //     diff1=n2ma1-nma1
# //         n2ma1=2*wma(close[1],round(keh/2))
# //         nma1=wma(close[1],keh)

# //     sqn=round(sqrt(keh))
# //         sqn=3.74 (round = 4?)

# // ==============================================

# // leadLine1 = avg(conversionLine, baseLine)
# // leadLine2 = donchian(laggingSpan2Periods)
# // conversionLine = donchian(conversionPeriods)
# // baseLine = donchian(basePeriods)



# // longCondition = n1>n2 and strategy.opentrades<ot and confidence>dt and close>n2 and leadLine1>leadLine2 and open<LS and MACD>aMACD
# //TO DO
