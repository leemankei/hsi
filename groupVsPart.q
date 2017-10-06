n:10000000;o:([] sym:n?`a`b`c`d`e`f; time:n?.z.T; data:n?100)
\ts select from o where sym = `a, time within 09:00 10:00   // 55 50332336
\ts select from o where time within 09:00 10:00,sym = `a    // 47 50332512

\ts meta st:`sym`time xasc o    // sym s    // 1848 536871888
\ts meta s:`sym xasc o          // sym s    // 388 469763520
\ts meta t:`time xasc o         // time s   // 1515 536871904
\ts select from st where sym = `a, time within 09:00 10:00  // 7 14680992
\ts select from st where time within 09:00 10:00,sym = `a   // 37 50332512
\ts select from s where sym = `a, time within 09:00 10:00   // 11 14680992
\ts select from t where sym = `a, time within 09:00 10:00   // 53 33555248
\ts select from t where time within 09:00 10:00,sym = `a    // 7 17826640

meta stp:update `p#sym from st  // sym p
meta sp:update `p#sym from s    // sym p
meta tp:update `p#sym from t    // 'u-fail
\ts select from stp where sym = `a, time within 09:00 10:00 // 6 14680992
\ts select from sp where sym = `a, time within 09:00 10:00  // 10 14680992

meta stg:update `g#sym from st  // sym g
meta sg:update `g#sym from s    // sym g    
meta tg:update `g#sym from t    // sym g, time s
\ts select from stg where sym = `a, time within 09:00 10:00 // 9 14680960
\ts select from sg where sym = `a, time within 09:00 10:00  // 15 14680960
\ts select from tg where sym = `a, time within 09:00 10:00  // 16 14680960
\ts select from tg where time within 09:00 10:00, sym = `a  // 7 17826640
