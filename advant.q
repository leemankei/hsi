Advent of CodeMan Kei Lee 12*[About][Stats][Leaderboard][Settings][Log out]
--- Day 4: The Ideal Stocking Stuffer ---

Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all the economically forward-thinking little girls and boys.

To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five zeroes. The input to the MD5 hash is some secret key (your puzzle input, given below) followed by a number in decimal. To mine AdventCoins, you must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...) that produces such a hash.

For example:

If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043 starts with five zeroes (000001dbbfa...), and it is the lowest such number to do so.
If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash starting with five zeroes is 1048970; that is, the MD5 hash of pqrstuv1048970 looks like 000006136ef....
Your puzzle answer was 117946.

--- Part Two ---

Now find one that starts with six zeroes.

Your puzzle answer was 3938038.

Both parts of this puzzle are complete! They provide two gold stars: **

At this point, you should return to your advent calendar and try another puzzle.

Your puzzle input was ckczppom.

You can also [Share] this puzzle.


pt1:
{ $["00000" ~ -1_raze string 3#md5 x,string y;y;y + 1] }["ckczppom"]/[1]
pt2:
{ $["000000" ~ raze string 3#md5 x,string y;y;y + 1] }["ckczppom"]/[1]






Advent of CodeMan Kei Lee 12*[About][Stats][Leaderboard][Settings][Log out]
--- Day 6: Probably a Fire Hazard ---

Because your neighbors keep defeating you in the holiday house decorating contest year after year, you've decided to deploy one million lights in a 1000x1000 grid.

Furthermore, because you've been especially nice this year, Santa has mailed you instructions on how to display the ideal lighting configuration.

Lights in your grid are numbered from 0 to 999 in each direction; the lights at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions include whether to turn on, turn off, or toggle various inclusive ranges given as coordinate pairs. Each coordinate pair represents opposite corners of a rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore refers to 9 lights in a 3x3 square. The lights all start turned off.

To defeat your neighbors this year, all you have to do is set up your lights by doing the instructions Santa sent you in order.

For example:

turn on 0,0 through 999,999 would turn on (or leave on) every light.
toggle 0,0 through 999,0 would toggle the first line of 1000 lights, turning off the ones that were on, and turning on the ones that were off.
turn off 499,499 through 500,500 would turn off (or leave off) the middle four lights.
After following the instructions, how many lights are lit?

Your puzzle answer was 377891.

--- Part Two ---

You just finish implementing your winning light pattern when you realize you mistranslated Santa's message from Ancient Nordic Elvish.

The light grid you bought actually has individual brightness controls; each light can have a brightness of zero or more. The lights all start at zero.

The phrase turn on actually means that you should increase the brightness of those lights by 1.

The phrase turn off actually means that you should decrease the brightness of those lights by 1, to a minimum of zero.

The phrase toggle actually means that you should increase the brightness of those lights by 2.

What is the total brightness of all lights combined after following Santa's instructions?

For example:

turn on 0,0 through 0,0 would increase the total brightness by 1.
toggle 0,0 through 999,999 would increase the total brightness by 2000000.
Your puzzle answer was 14110788.

Both parts of this puzzle are complete! They provide two gold stars: **

At this point, you should return to your advent calendar and try another puzzle.

If you still want to see it, you can get your puzzle input.

You can also [Share] this puzzle.

s:select string s from ("SS";enlist ";") 0: `:/tmp/d6.txt
m:1000 cut 1000000#-1
v:value exec p1,p2,a from update "I"$"," vs/: p1, "I"$"," vs/: p2 from update a:("nf "!({x:1};{x:-1};{x*-1}))@os[;6], p1:first each -2_/:-3#/:s, p2:first each -1#/:s from update s:" " vs/: s, os:s from s
fm:{[m;p1;p2;f] .[m;{ (x[0;0] + til 1 + abs (-) . x[;0]; x[0;1] + til 1 + abs (-) . x[;1])} (p1;p2);f]}/[m;v[0];v[1];v[2]]
sum sum fm

m:1000 cut 1000000#0
v:value exec p1,p2,a from update "I"$"," vs/: p1, "I"$"," vs/: p2 from update a:("nf "!({x+1};{0|x-1};{x+2}))@os[;6], p1:first each -2_/:-3#/:s, p2:first each -1#/:s from update s:" " vs/: s, os:s from s


d9:
count {raze (string count each cut[i;x]),'x[i:where differ "I"$/:x]}/[50;(),"1113122113"]


d10:
pd:exec (asc each s,'d)!c from p:update s:t[;0], d:t[;1] from update `$"to" vs/: t from flip `t`c!("*I";"=") 0: `:/tmp/d9.txt
getCombination:{y@/:{$[x=1;y;raze .z.s[x-1;y]{x,/:y except x}\:y]}[x;til count y]}
max {sum pd each asc each xx where 2 = count each xx:(2 cut x),(2 cut 1_x)} each r:getCombination[count s;s:distinct raze p`s`d]


D:("S S I";" ")0:`:/tmp/d9.txt    
T:(flip d 0 1)!(d:D,'D 1 0 2)2


(&/;|/)@\:+/'T'(1_,':)'?{(-#d)?d:?,/D 0 1}'!100000

p:{(x-1){,/(>:'t=/:t:!1+#*x)@\:0,'1+x}/,0}
(&/;|/)@\:+/'T'(1_,':)'d p@#d:?,/D 0 1



{raze(count each runs),'first each runs:where[differ x] cut x} x:"131112"

d:.j.k first first ((),"*";"%") 0:`:/tmp/d12.txt

{ type each x } 


{ $[((99h = t) & any "red"~/:x) | 10h = t:type x;0;-9h=t;x;sum .z.s each x] } x:d

[`e;0;1;`f]
{ $[10h = t:type x;0;-9h=t;x;sum .z.s each x] } x:d[`e;0;0;`e`c`g]

d[`e;0;0;`d]
d[`e;0;0;`e`c`g]
d[`e;0;0;`d]
any "red"~/:x 
d[`e;0;0]


{ type x } each x

sum 86 23 120 169 -19

sum (0,())
x:x where l
sum x[f]


type "a"    / 10
type `a    / 11
type 1f    / 9



/d13
perm:{y@/:{$[x=1;y;raze .z.s[x-1;y]{x,/:y except x}\:y]}[x;til count y]}
perm:{{raze x{x,/:y except x}\:y}[;y]/[x-1;y]};


perm[3;til 5]

r:("S SI      *";" ") 0: `:/tmp/d13.txt
r[3]:`$-1_/:r[3]
r[1]:(`gain`lose!1 -1)r[1];
relate:@[flip `p1`p2!r[0 3];`hap;:;(*'). r[1 2]]
ppl:distinct raze r[0 3]    / `Alice`Bob`Carol`David`Eric`Frank`George`Mallory
perm[count p)pl;ppl]
rd:exec (p1,'p2)!hap from relate


k:n,reverse each n:`me cross ppl
rd,:k!(count k)#0

allseats:perm[count ppl;ppl,:`me]

allseats:allseats,'first each allseats

x:first allseats



h1:allseats!{sum rd@/:s,reverse each s:raze 2 cut/:(x;1_x) } each allseats

max h1

/d14
f:("S  I  I      I ";" ") 0: `:/tmp/d14.txt
t:2503

f:flip -2_flip f

flip `deer`speed`fly`reset!f


f[0]!(((*). f[1 2]) * s:t div p) + ((1 0)@s mod 2) * f[1] * t mod p:(+) . f[2 3]


race:t#/:raze each { p:tt#/:cut[tt:(+). x[2 3];t#0]; .[p;(til count p;til x[2]);:;x[1]]  } each flip f


max (f[0]@key res)!value res:count each group raze where each snap =' max each snap:flip sums each race


/ good addone by base 26
nextLetter:v!1 rotate v:"j"$.Q.a except "iol";
addOne:{?[1=-1_ 1i,prds 97=n; n:nextLetter x; x]}
"c"$addOne x:"j"$"az"
"c"$addOne x:"j"$"za"
"c"$addOne x:"j"$"ab"




twoDouble:{(1<sum 1<c)or any 3<c:deltas where differ x,0}

twoDouble x:1 1 0 2 2 0
