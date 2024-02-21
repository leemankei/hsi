n:10000000;
t:([] sym:n?14; d1:n?1000; d2:n?`a`b`c`d; d3:n?.z.d);
idx:asc 5000?n;
c:`sym`d1`d2;
`:hdb/splay/ set .Q.en[`:hdb] t;
`:hdb/flat set t;
system "l hdb";

\ts r0:splay . (idx;c)   // 30 197456j
\ts r1:?[`splay;enlist (in;`i;idx);0b;c!c] // 32 394448j
\ts flip c!flip `flat . (idx;c)
\ts flip c!flip `t . (idx;c)
