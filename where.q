
di:group li:1 2 3 3 2 1 1
di:group li:10000000?10000j

\ts {@[x;y;:;z]}/[sum[count each di]#0N;value di;key di]  // crazy lonh
\ts (where count each di) iasc raze di  // better

\ts @[sum[c]#(1#key di)[1];raze di;:;where c:count each di] // 345 335479616j
\ts @[count[c]#(1#key di)[1];c:raze di;:;where count each di]   // 341 268436320j
\ts @[count[c]#first key di;c:raze di;:;where count each di]   // 341 268436320j
