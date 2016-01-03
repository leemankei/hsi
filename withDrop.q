// http://www.aastocks.com/tc/ltp/rtquote.aspx?symbol=02800
amt:1;transactionLeadTime:0;    / elapsed time to execute order
hsi:asc ("DFFFFJF";enlist csv) 0: `:/tmp/hsi.csv;   // http://finance.yahoo.com/q/hp?s=%5EHSI+Historical+Prices // http://real-chart.finance.yahoo.com/table.csv?s=%5EHSI&d=6&e=7&f=2015&g=d&a=11&b=31&c=1986&ignore=.csv    

backtest:{[hsi;amt;transactionLeadTime;lastday;backday;ms]
    0N!"backtest ",(string backday)," ",-3!ms;
    t2:update transaction:sums differ bought from 
    update bought:fills ?[0 = transactionLeadTime xprev shouldBuy;0N;transactionLeadTime xprev shouldBuy] from
        ![select from ?[hsi;();0b;(`Date`Open`Close,a)!`Date`Open`Close,(mavg),/:ms,\:`Close] where Date within lastday - (backday;0);();0b;(enlist `shouldBuy)!enlist (deltas;(>),(first;last)@\:a:`$"m",/:string ms)];    /  

    t3:update transactionGain:(-).'SellBuyPrices, chg:(%).'SellBuyPrices from 
        update reverse each SellBuyPrices from 
            (0!select SellBuyPrices:(last nextClose;first Close),first bought by transaction from update nextOpen:Close ^ next Open, nextClose:Close ^ next Close from t2) 
            where bought = -1;
    / buy at same day Close
    / sell at next day Close

    // TODO realize with last Close if ending bought = 1

    t2 lj 1!@[t3;`amt;:;{x * y}\[amt;t3`chg]]
    };

ms:2 19;backday:360;lastday:.z.d;
select Date,Close,m2,m19 from
backtest[hsi;amt;transactionLeadTime;.z.d;120;ms]
