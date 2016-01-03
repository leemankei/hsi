// http://www.aastocks.com/tc/ltp/rtquote.aspx?symbol=02800
/ system "wget \"http://real-chart.finance.yahoo.com/table.csv?s=%5EHSI&d=",(-3!`dd$.z.d),"&e=",(-3!`mm$.z.d),"&f=",(-3!`year$.z.d),"&g=d&a=11&b=31&c=1986&ignore=.csv\" -q -F -O c:/tmp/hsi.csv";
amt:1;transactionLeadTime:0;    / elapsed time to execute order
hsi:asc ("DFFFFJF";enlist csv) 0: `:/tmp/hsi.csv;   // http://finance.yahoo.com/q/hp?s=%5EHSI+Historical+Prices // http://real-chart.finance.yahoo.com/table.csv?s=%5EHSI&d=6&e=7&f=2015&g=d&a=11&b=31&c=1986&ignore=.csv    

getPercentile:{x@`int$.01 * y * count x:asc x where not null x};
backtest:{[hsi;amt;cost;transactionLeadTime;lastday;backday;ms]
    0N!"backtest ",(string backday)," ",-3!ms;
    t2:update transaction:sums differ bought from 
    update bought:fills ?[0 = transactionLeadTime xprev shouldBuy;0N;transactionLeadTime xprev shouldBuy] from
        ![select from ?[hsi;();0b;(`Date`Open`Close,a)!`Date`Open`Close,(mavg),/:ms,\:`Close] where Date within lastday - (backday;0);();0b;(enlist `shouldBuy)!enlist (deltas;(>),(first;last)@\:a:`$"m",/:string ms)];    /  

    t3:update transactionGain:(-).'SellBuyPrices, 
        chg:(%).'SellBuyPrices 
        from update reverse each SellBuyPrices from (0!select first bought, SellBuyPrices:(last nextClose;first nextOpen)
            by transaction from update nextOpen:Close ^ next Open, nextClose:Close ^ next Close from t2) where bought = -1;

    t4:update chg - cost from select from t3 where bought = 1;

    / update amt:prds chg from t4
    (lj/) (t2;1!t3;1!@[t4;`amt;:;{x * y}\[amt;t4`chg]])
    };

cost:.0;ms:2 32;lastday:.z.d;backday:lastday - 2000.01.01;
outcome:backtest[hsi;amt;cost;transactionLeadTime;lastday;backday;ms];  // investment outcome

?[outcome;enlist (>;`transaction;(+;-1;(max;`transaction)));0b;a!a:`Date`Close,`$"m",/:string ms]   // market trend since last transaction

select cnt:count i, gainCnt:sum transactionChg > 1, chg10:getPercentile[transactionChg;10], 
    chg50:getPercentile[transactionChg;50], chg90:getPercentile[transactionChg;90], 
    avgChg: avg transactionChg, avg duration by bought from    // action summary
    transactionSummary:select enterOn:first Date, 
        enterPrice:last SellBuyPrices[;0], exitPrice:last SellBuyPrices[;1],
        first bought, duration:count i, transactionChg:first chg, first amt by transaction from outcome

`enterOn xdesc select enterOn, transactionChg, amt from transactionSummary where bought = 1   // performance summary


\

backdays:7 14 60 90 120 180 365 3650 5475 7300 10415; 
short:1 2 3 5;
long:5 7 14 19 30 50;
mss:c where 0 > (-) .' c:short cross long;

r:{[hsi;amt;transactionLeadTime;lastday;backday;ms]
    .[{[hsi;amt;transactionLeadTime;lastday;backday;ms](`short`long`since`back!ms,(.z.d - backday),backday),exec transactions:count where shouldBuy <> 0, gross:last amt where not null amt from backtest[hsi;amt;transactionLeadTime;lastday;backday;ms]};
        (hsi;amt;transactionLeadTime;lastday;backday;ms);{[ms;backday](`short`long`since`back!ms,(.z.d - backday),backday),`transactions`gross!(0j;1f)}[ms;backday]]
    } [hsi;amt;transactionLeadTime;.z.d] ./: backdays cross enlist each mss;

// TODO generate N-days rolling comparison model
select from r where gross = (max;gross) fby since

select Date, Close, m1, m7 from 

backtest[hsi;amt;transactionLeadTime;.z.d;120;2 19]



asc ([] ed),'raze{select last Date where shouldBuy <> 0, last bought, last chg where not null chg from backtest[hsi;amt;transactionLeadTime;x;backday;ms]} each ed:.z.d - 30 * til 100

