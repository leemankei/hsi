// reduce mem consumption when flipping lists
someFunc:sum; datalists:15000 cut 60000?10
\ts r0:someFunc each flip datalists                        // 1 1593664
\ts r1:someFunc each flip ![count[datalists]#`;datalists]  // 3 503072
r0 ~ r1     // 1b

// :: execute previous cmds once args provided
xy:(1 3 5; 1 2 6)
{ sum abs x } xy
'[sum;abs] xy
sum abs xy
( sum abs ::) xy

// compose function
f:('[sum;enlist])
f[1;2;3] // 6

// functional apply
t:([] data:"abc",/:string til 5; k:("a";"";"c";"d";""))
t[`data]:@[t`data;i;:;(count i:where 0 = count each t`k)#enlist "newStr"]
/ or
.[t;(i;`data);:;(count i:where 0 = count each t`k)#enlist "newStr"]


// first N by sym
n:1000; q:([] sym:n?`1; time:asc n?.z.T; price:n?100f; size:n?1000)
q raze value exec 5#i by sym from q
q raze value 5#/:group q`sym


// lookup col values according to a col
n:100000;t:([] d:n?4; d0:n?10; d1:n?100; d2:n?1000; d3:n?10000)
\ts update r:d^nd@'d from update nd:(til 4)!/:flip(d0;d1;d2;d3) from t      / 48 13298448j
\ts ![t;();0b;(enlist `n)!enlist (@';(@;t;(`$;(,/:;"d";(string;`d))));`i)]  / 43 5298560j



// cutting list into trunks
\ts:100 { flip x cut y,#[x - mod[count y;x];d:((),(first y))[1]] }[5;d] 
\ts:100 { flip (x cut y)[;til x]} [5;d]



// explained mmin (use of ': and /)
mmin    / {(x - 1)&':/y}, 3 mmin 5 3 7 9 1 -> 5j 3j 3j 3j 1j
/ each prior y become monadic 
({(x;y)}':) 5 3 7 9 1   / (5j 0Nj;3j 5j;7j 3j;9j 7j;1j 9j)
/ thus min each prior is monadic
(&':) 5 3 7 9 1   / 5j 3j 3j 7j 1j
/ thus scan/over on monadic means iterate the function for N times
2 {(x;y)}':\ 5 3 7 9 1  / (5j 3j 7j 9j 1j;(5j 0Nj;3j 5j;7j 3j;9j 7j;1j 9j);((5j 0Nj;`long$());(3j 5j;5j 0Nj);(7j 3j;3j 5j);(9j 7j;7j 3j);(1j 9j;9j 7j)))
/ finally
2 &':\ 5 3 7 9 1    / (5j 3j 7j 9j 1j;5j 3j 3j 7j 1j;5j 3j 3j 3j 1j)



// lookup raw cols 
/ .query.rawkolz x:`a`b`c!((last;`ra);(+;(%;`rb1;enlist `EURUSD);`rb2);`rc)    / (`rc`ra`rb2`rb1)!`rc`ra`rb2`rb1
.query.rawkolz:{[x]
    // if aggregations are empty leave as is
    if[x~();:x];
    // pull distinct required columns out of x and return a dictionary
    kolz:distinct .query.recursekolz x;
    kolz!kolz
    };
// x - column aggreagtion or group by
.query.recursekolz:{[x]
    // get col names that are syms on first level of nesting
    kolz:((),x) where (),-11h=ty:type each x;
    // if any of these cols are like e.g. time.minute or time.month replace with just `time
    /(kolz where kolz like "time*"):`time;
    if[any kolz like "*[tT]ime*";kolz:`${first "." vs x} each string kolz];
    // if there is a general list on first level select it
    l:((),x) where (),chk:0h=ty;
    // if no general list function returns kolz 
    // else run the general list through this function again i.e. down to the second level of nesting.
    // join any cols found here to kolz and return. Loop through each level of nesting
    $[all not chk; kolz;raze kolz,.z.s x:raze l]
    };



// getting nulls
{ (enlist ((),x)[1])$() } each (`a;1i;1j;1f;1b;.z.d;.z.p)   / get null of given atom
{((key (),x))$()} each (1j;2i;`a)    / get empty list of given atom type 



// group ids by dates
dates:.z.d - 2 2 1 1 1 0;id: til 6;
id@group dates



// moving weighted average
// moving last m elements
melem:{  ((flip (0|c - x;c:1 + til count y)) cut\:y)[;0] };
n:20;p:1 + n?1f;w:n?100;m:3;
melem[m;w] wavg' melem[m;p] 



// create local hdbs
{[path;tbl;n;dt]
    (.Q.dd/[path;dt,tbl,`]) set .Q.en[path; ([] date:dt; sym:n?`3; time:n?23:59:59.999; data:n?100)]
    // or
    / tbl set ([] date:dt; sym:n?`3; time:n?23:59:59.999; data:n?100);      // create a random global table t 
    / .Q.dpft[path;dt;`sym; tbl]     // save date partitions, should find the hdb as c:\temp
    }[`:/temp;`t;3] each .z.d - til 10    // run for past 10 days



// Apply same funct to all rows
n:100000;tt1:([] c:n?01b; d:n?10);
\ts select { ?[x;10;100] + y } . (c;d) from tt1     // much faster
\ts select { $[x;10;100] + y } ' [c;d] from tt1


 
// Apply diff funct to each rows
n:10;tt:([] time:asc n?.z.t; sym:n?`1; d1:n?10; d2:n?100; f1:n?({ x + y};{ x * y};{x - y}); f2:n?({10f * x};{x % 10}));
/ try:
update r1:f1 .'(d1,'d2), r2:f2@'d1 from tt
/ or:
update r1:f1 .' flip(d1;d2) from tt
/ in functional form
![tt;();0b;(enlist `r1)!enlist (.';`f1;(flip;(enlist;`d1;`d2)))]
![tt;();0b;(enlist `r1)!enlist (.';`f1;(,';`d1;`d2))]
![tt;();0b;(enlist `r2)!enlist (@';`f2;`d1)]



// Apply iterative functions 
/ followings are equivalent:
/ value (xcol;`date`sym;t)
/ xcol[`date`sym;t]
/ .[xcol;(`date`sym;t)]
/ (xcol).(`date`sym;t)
n:10;t:([] date:n?.z.d; ccy:n?`3; time:n?23:59; data:n?10)
{z[x;y]}[`date`sym]/[t;(xcol;xkey)]




// using dot index
d:((1 2 3;4 5 6 7);(8 9;10 1;11 12);(13 14;15 16 17 18;19 20))
d . 1 2     // d[1;2]
d . 1 2 0    // d[1;2;0]
d . (::),1  // d[;1]
d . (),1    // d[1]
d . 1,(::),0    // d[1;;0]



// Avg Row Count for last week
rowCount:{$[2 = count x;
        (,'/){1!(`table,`$"cnt_",ssr[string x;".";""]) xcol rowCount x } each getDateList[x@0;x@1];
        ([] table:t; cnt:raze {count get ` sv (hsym `$getenv`HDB_DATA_DIR;x;y;`time)} [`$string x] each t:.Q.pt)
    ]};
?[rowCount d;();0b;`table`c!(`table;(avg each;(flip;(enlist,`$"cnt_",/:(string (first d:(`week$.z.d) - 7 3) + til 5) _\:/ 4 6))))]
/ or
@[aa;`cnt;:;avg ?[aa;();();a!a:1 _ cols aa:0!rowCount (`week$.z.d) - 7 3]]
/ or
aa,'([] cnt:?[aa;();();(avg;(enlist,1_ cols aa:rowCount (`week$.z.d) - 7 3))]) 



// Callbacks
.z.pw:{[u;p] 0N!"pw:",-3!(u;p); 1b}       // validate user
.z.po:{[h] 0N!"po:",string h} // open
.z.pg:{[x] 0N!"pg"; value x}  // get
.z.ps:{[x] 0N!"ps"; value x}  // set / async
.z.ph:{[x] 0N!"ph"; value x}  // http get
.z.pp:{[x] 0N!"pp"; value x}  // http post
.z.pc:{[h] 0N!"pc:",string h} // close
.z.vs:{[x;y] 0N!"vs:",-3!(x;y;value x)}       // set value
.z.exit:{[x] 0N!"exit:",string x} //exit code
0N!"ready"



// Complicated fby clause
t:flip `sym`data!(`p#`a`a`a`b`b`b`b`b`c`c`c`c`d`d`d`d`d`d`d`d;10 10 30 20 30 40 40 40 10 20 20 40 10 10 20 20 30 30 40 40)
  
select sd:sum distinct data, s:sum data by sym from t
/ a     40  50
/ b     90  170
/ c     70  90
/ d     100 200 

/ I want to find out those records with 80 < sum distinct data by sym (i.e. b and d)
select from t where 80 < ({ sum distinct x };data) fby sym

t:([] a:2 2 2 3; b:0 2 2 2; c:7 8 9 0)
  
select  from t where 1 < (count;c) fby ([] a;b)
?[t;enlist (<;1;(fby;(enlist;count;`i);(flip;(!;enlist a;enlist,a:`a`b))));0b;()]
/ a b c
/ 2 2 8
/ 2 2 9
 
select from t where 1 < (count;c) fby a
?[t;enlist (<;1;(fby;(enlist;count;`i);`a));0b;()]
/ a b c
/ 2 0 7
/ 2 2 8
/ 2 2 9



// Convert complicated where clause into functional form
sd:-1 + ed:2014.03.18;
trd:(`DUB`INM`HKH`LOH`NYK!5#enlist enlist (0nz;0nz)),trd:exec (starttime,'endtime) by siteCode from raze getStartEndByDateSite[;`HKH`LOH`NYK] each getDateList[sd;ed];
 
select min eventCaptureTime, max eventCaptureTime by siteCode,financialDate from
want:select financialDate, siteCode, eventCaptureTime from trade where date within (sd - 1; ed), any each eventCaptureTime within/:'trd@siteCode
 
/ consider this
ttt:select siteCode, eventCaptureTime, any each eventCaptureTime within/:' trd@siteCode from trade where date within (sd - 1; ed)
/ and
any 10 within/:(10 15; 9 20; 30 40)
 
{[x;y;z] any each y within/:'x[z]} [trd;ttt`eventCaptureTime;ttt`siteCode]
~
{[x;y;z] any y within/:x[z]}[trd]'[ttt`eventCaptureTime;ttt`siteCode]
 
?[ttt;enlist ({[x;y;z] any each y within/:'x[z]} [trd];`eventCaptureTime;`siteCode);0b;()]
~
?[ttt;enlist ({[x;y;z] any y within/:x[z]} [trd]';`eventCaptureTime;`siteCode);0b;()]
 
/ -->
getData[sd - 1;ed;{ ?[`trade;y;0b;x!x] }[`financialDate`siteCode`eventCaptureTime];enlist ({[x;y;z] any each y within/:'x[z]}[trd];`eventCaptureTime;`siteCode)]
/ or
getData[sd - 1;ed;{ ?[`trade;y;0b;x!x] }[`financialDate`siteCode`eventCaptureTime];enlist ({[x;y;z] any y within/: x[z]}[trd]';`eventCaptureTime;`siteCode)]



// Exponential Moving Average
/ The function is:
/ y := alpha * x + (1-alpha) * (prev y) 
/ where 
/ alpha = user specified consistent 
/ x = current data point
/ y = result 
/ based on : {(z*x) + y*1 - x}[alpha:.1]\[initial:0;data:1 + til 10]  // 0.1 0.29 0.561 0.9049 1.31441 1.782969 2.3046721 2.8742049 3.4867844 4.138106
n:20;t:([] x:1 + til 10);
expMAvg:{{(z*x) + y*1 - x}[x]\[0;y]};
update r:expMAvg[.1] x from t



// Get all subset combinations of a list
{y@/:{$[x=1;y;raze .z.s[x-1;y]{x,/:y except x}\:y]}[x;til count y]} [3; `a`b`c`d`e]



// Get null based on datatype
a:10; // or `1, or .z.d
(enlist a)[1]
L:3?`1; // for a list
L @ count L



// hclose by callback
/Requester
kdbadm@gbs00430:/home/users/kdbadm> q -p 2222
q)h:hopen `::1111
q)(neg h)({0N!"wait from ",string .z.w; system "sleep 5";0N!"return"; (neg .z.w)({0N!"callback";hclose x};x); 0N!"continue remaining"};h)
q)"callback"
q)h("\\p")
': Bad file number
q)
/Server
kdbadm@gbs00430:/home/users/kdbadm> q -p 1111
q)"wait from 5"
"return"
"continue remaining"

 
 
// list to cols
/ to get derivedtrade mtmBasisPoints into cols when offsets are 0 10 30sec
 t:100#select mtmBasisPoints, offsets from derivedtrade where date = 2014.04.03, sym = `EURUSD
flip `mtm0`mtm10`mtm30!flip exec mtmBasisPoints@'offsets bin/:\: 0 10000 30000 from t



// Looking for bad sym
-100#sym    // identify bad syms like 0011G302T35QT2YB
 dt:2013.09.26;  // guess it's in recent HDB
symInspect:raze {[dt;t]
    .[{[dt;t] c:exec c from (0!meta t) where t = "s";
    data:c!get each ` sv/: (`$":",getenv`HDB_DATA_DIR),/:(`$string dt),/:t,/:c;
    (enlist t)!enlist enlist distinct each data
    / (enlist t)!enlist enlist count each/: ddd:group each data
    };(dt;t);{0N!x;()}]
} [dt] each tables`;        // collect all sym used on the date
 
where raze {(enlist x)!enlist any value any each (any each symInspect = `0011G302T35QT2YB) x} each key symInspect   // search which table contain the bad sym
symInspect `pnltrade        // show the sym used by each col
symInspect . `pnltrade`uti  // show the sym of a particular col
 
/ for RTD
symInspect:raze {[t]
    @[{[t] c:exec c from (0!meta t) where t = "s";
    data:c!t c;     // does not support intra-day rolled tables
    (enlist t)!enlist enlist distinct each data
    };(t);{0N!x;()}]
} each tables`;



// Manipulate table cols
/ Group cols into list
t2:([] sym:5?`1; d0:5?10; d1:5?10; d2:5?10);
update nd:flip(d0;d1;d2) from t2    // grouped d0-2 into nd
![t2;();0b;(enlist `nd)!enlist (flip;(enlist,`$"d",/:string til 3))]  // or in functional form

/ Expand listed col into cols
c:();do [5;c,::enlist 10?100];
t:([] sym:5?`1; data:c)     // a table with data as I, each with 10 atoms
nc:`$"d",/:string til 10; // define new cols name
t,'flip nc!flip exec data from t    // expand the data col into d0-9
/ or
exec !/:[`sym,nc;sym,'data] from t



// Max gap in a list
x:2 4 5 4 8 3 1 5;
/ find max drop and up within the list
update maxdrop:nn - x, maxup:nm - x from ([] x),'flip `nn`nm!reverse each (mins;maxs)@\:reverse x
/ or
(min;max)@'(reverse each (mins;maxs)@\:reverse x) -\: x
 
/ find the max drop between 2 consecutive points
maxDrop:{ min 0 & deltas fills x };
 
/ find the max up between 2 consecutive points
maxUp:{ max 0 | 1_deltas fills x };



// Modify script on the fly
/ declare the functions
.myFunc.f:{ x + y};
.myFunc.g:{ x * y};

/ save it down as if conventional function scripts
`:/opt/eFX/kdb/mi/script/myFunc.q 0: enlist ".myFunc:",-3!.myFunc
 
/ start a new process and load the scripts
\l /opt/eFX/kdb/mi/script/myFunc.q

/ runnable functions
.myFunc.g[3;2]
 
/ Or, just save and load in binary form
`:/tmp/ff set .myFunc
.myFunc:get `:/tmp/ff



// apply list of data to func
f:{x + y}; d:2 cut til 1000;
/ fastest
.[f;flip d;`fail]
/ slowest
@[{f .'x};d;{`fail}]
/ or
@[{f ./:x};d;{`fail}]



// Pass and invoke function to remote in protected mode
f:{ x + y + z };
/ local
@[value;(f;1;2;3);{-1}]     // 6
@[value;(f;1;2;`a);{-1}]        // -1
/ via handle
h:0;
@[h;(f;1;2;3);{0N!"Failed:",x}]       // 6
@[h;(`f;1;2;3);{0N!"Failed:",x}]  // "Failed:f"
@[h;(f;1;2;`A);{0N!"Failed:",x}]  // "Failed:type"

/ Run functions in protected mode
.test.ok:{1b};
.test.fail:{0b};
.test.error:{'error};
 
@\:[` _ .test;[]]   // unprotected -> 'error
![key t;@'[{x[]};value t:` _ .test;{0b}]]   // protected with same(empty) arg -> `ok`fail`error!100b
 
![key t;.'[{x y};flip (value t:` _ .test;1 2 3);{0b}]]      // protected with different arg -> `ok`fail`error!100b


// populate action from RTD
/ in RTD
.u.m:.u.h;
f:{ x({`a1 set `A1};`); if [x({0N!system"p";`m in key `.u};`); x({`a2 set `A2};`); x(.z.s;x(value;`.u.m))]};
f 0 / RTD and CTP have a1 and a2, TP only has a1



// q like unix -h
f:{trim(string .1*7h$10*x%1^n i),'"KMG"@i:bin[n:1*\3#1000;x]}
f[0 12 1000 1999 54300 1280000 1230000000]  // (enlist "0";"12";"1K";"2K";"54.3K";"1.3M";"1.2G")



// Replacing each
n:100000;p:update ask:bid + n?.5 from ([] bid:1 + n?1f)
\ts ungroup select avg (bid;ask) from p / 0j 2097792j
\ts select avg each flip (bid;ask) from p   / 5j 7946368j



// sort by my sequence
/ For list
order:`first`second`third`fouth`fifth;
data:20?order;  // `second`first`first`second`third`fouth`fifth`fifth`third`fifth`fifth`fifth`fifth`third`first`third`fifth`fifth`second`fifth
order asc order ? data      // `first`first`first`second`second`second`second`second`second`third`third`third`third`third`third`third`fouth`fifth`fifth`fifth
/ For Table
t:([] oCol:10?order; data:10?100)
t iasc order ? t`oCol



// table as criteria
/ to delete rows based on some list values
n:100;t:([] date:2014.07.20 + n?3; siteCode:n?`LOH`HKH`NYK; data:n?100);
toDel:,'[2014.07.20 + 3?3;3?`LOH`HKH`NYK]
delete from (t lj 2!update delme:1b from flip `date`siteCode!flip toDel) where delme
/ or
delete from t where ([] date;siteCode) in flip `date`siteCode!flip toDel    // fastest
/ or
delete from t where in\:[flip (date;siteCode);toDel]

t:([] sym:20?`EUR`USD`JPY`AUD; direction:20?`BUY`SELL; data:20?100)
select from t where ([] sym; direction) in ([] sym:`AUD`EUR`JPY; direction:`BUY`BUY`SELL)
/ or
?[t;enlist (in;(flip;(!;enlist ca;(enlist,ca:`sym`direction)));([] sym:`AUD`EUR`JPY; direction:`BUY`BUY`SELL));0b;()]



// update dictionary of tables
mt:t!0!/:meta each t:.Q.pt      // build a dictionary of table schema (unkeyed)
mt`ecnorder                     // id cols are empty
.[`mt;(key[mt];`t);"C"^]      // change empty character (dynamic list) as "C"
mt`ecnorder                     // id cols are C



// updating atoms of list
/ simple list --> general list  (NOT allowed --> 'type)
/ general list --> general list (allowed)
@[`a`b;0 1;string]      // 'type
/ workaround by converting the simple list into generic list, e.g.:
1_@[(::),`a`b;1 2;string]  
/ following give (enlist "a";enlist "b")
{1_@[x;where 10h <> type each x:(::),x;string ]} `a`b
{1_@[x;where 10h <> type each x:(::),x;string ]} ("a";`b)
{1_@[x;where 10h <> type each x:(::),x;string ]} "ab"



// Using over for multivalent function
t:([] time:asc 10?.z.t; sym:10?`1; data:10?100);
/ rename the table columns with renTableCol[t;o;n]
renTableCol:{[t;o;n] cs:cols t; cs[where cs = o]:n; cs xcol t };
renTableCol/[t;`time`sym;`t`s]  // == renTableCol[renTableCol[t;`time;`t];`sym;`s]
/ a better renTableCol:{[t;o;n] @[c;?[c:cols t; (),o];:;n] xcol t}



// Using Q Password file
/ Use -u option (http://code.kx.com/wiki/Reference/SystemCommands#.5Cu_-_reload_user_password_file) & http://code.kx.com/wiki/Reference/Cmdline & http://code.kx.com/wiki/Reference/dotzdotpw
/ The password file is unencrypted user : password pairs
/ (cannot use = nor space as delimiter)
/ vi pwdfile
/ user1:123456
/ user2:
// Start protected process with password file
/ q -p 1234 -u pwdfile
// Access the protected process via handle
/ q)hopen `::1234
/ 'access
/ q)hopen `::1234:user1:bad
/ 'access
/ q)hopen `::1234:user1:123456
/ 4
/ q)hopen `::1234:user2
/ 5
/ q)
/ Direct connection to the protected process also need correct login
/ [kdbadm:]$qcon :1234
/ :1234>\p
/ :1234>
/ [kdbadm]$qcon :1234:user1:123456
/ :1234>\p
/ 1234
/ :1234>

// apply default by levels
groupConfig:{[data;kcol;cfg;defaults]
    ndata[`validKey]:(((),cols[ck])#ndata:ungroup ![data;();0b; (kcol;`okey)!(((,\:);kcol;enlist defaults);kcol)]) in ck:key cfg;
    grpk:`okey,cols[ck]except kcol;
    ndata2:0!?[ndata;enlist (`validKey);{x!x,:()} grpk; enlist[kcol]!enlist (first;kcol)];
    xcol[kcol; grpk#ndata2],' cfg cols[ck]#ndata2
    };

groupConfig2:{[data;kcol;cfg;defaults]
    ndata:ungroup ![data;();0b; (kcol;`okey)!(((,\:);kcol;enlist defaults);kcol)];
        c:enlist (in;(flip;(!;enlist a;enlist,a:cols key cfg));key cfg);
    mdata: 0!?[ndata;c;{x!x}mk:`okey,cols[key cfg] except kcol; enlist[kcol]!enlist (first;kcol)];
    / xcol[kcol; ![mdata;();0b;enlist kcol]],'cfg cols[key cfg]#mdata 
        ?[mdata;();0b;a!mk] ,'cfg cols[key cfg]#mdata 
    };



AggInfoSym:([] datetype:`daily`qend`mend; volHorizon:20 18 15; vcHorizon:10 8 6; vcAggMethod:`median; extraParameter:`; sym:`DEFAULT);
cfg: `sym`datetype xkey AggInfoSym,
(update sym:`HK, vcAggMethod:`mean, vcHorizon:4 from select from AggInfoSym where datetype = `qend),
(update sym:`d, vcAggMethod:`mean, vcHorizon:12 from select from AggInfoSym where datetype = `daily),
(update sym:`d, vcAggMethod:`mean, vcHorizon:7 from select from AggInfoSym where datetype = `mend);
data:([] sym:`a`b`c`d; datetype:`daily`qend`mend`daily);
defaults:`HK`DEFAULT;
kcol:`sym;
\ts r1:groupConfig[data;kcol;cfg;defaults]
\ts r2:groupConfig2[data;kcol;cfg;defaults]

// mmed
{ med each { neg[x] sublist y,z }[x]\[();y] } [3;14 10 13 13 18 15 15 16 23 15 9 0 9 14 16 10 14 17 23 15]

// look for index of a string
indexOf:{ where (count[y] sublist/:(1_)\[x]) ~\: (),y }
indexOf["cdabcbdebcdbbdfgb";"bcd"]

// \ts baseTable:.h.unen `debt
.h.unen:{ @[x;where within[type each flip x:select from x;20 50];get] }

