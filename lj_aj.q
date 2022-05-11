t:select last p by sym, time from `time xasc ([]sym:1000?`1;time:08:00+1000?100; p:1000?100.0)

tAsOf: flip `sym`time!flip (distinct (0!t)`sym) cross 08:00+10 * til 11;

aj[`sym`time;tAsOf;0!t] ~ tAsOf lj `s#t    // 1b

n:10000000;
t:select last p by sym, time from `time xasc ([]sym:n?`6;time: 08:00:00+n?10000; p:n?100.0);
tAsOf: flip `sym`time!flip (distinct (0!t)`sym) cross 08:00:00 + 600 * til 18;
  
\t aj[`sym`time;tAsOf;0!t]
62080
 
\t tAsOf lj `s#t
53697

// find first value after a certain time, negate the times before and after the join. Note that this requires us to sort the table again.
t:select last p by sym, time from `time xasc ([]sym:1000?`1;time:08:00+1000?100; p:1000?100.0);
t
sym time | p      
---------| --------
a   08:01| 84.7615
a   08:02| 75.6359
a   08:03| 40.04761
a   08:04| 33.46354
a   08:06| 5.160162
a   08:09| 92.26709
a   08:11| 67.64829
a   08:12| 74.69208
a   08:19| 56.47976
a   08:21| 9.464025
..
 
tAsOf: flip `sym`time!flip (distinct (0!t)`sym) cross 08:00+10 * til 11;
update time: neg time from (update time: neg time from tAsOf) lj `s# `sym`time xasc update time: neg time from t;
sym time p
-------------------
a 08:00 84.7615
a 08:10 67.64829
a 08:20 9.464025
..
