n:9; quotes:([] date:.z.d - n?5; sym:n?`a`b`c; price:n?10f)

quotes:.Q.en[`:.] quotes;

{[quotes;d]
    .Q.dd[.Q.par[`:.;d;`quote];`]
    upsert
    delete date from select from quotes where date = d
    }[quotes] each distinct quotes`date

\cat /tmp/work/db/par.txt
/tmp/work/0
/tmp/work/1
/tmp/work/2
/tmp/work/3
