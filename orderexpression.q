s: (!). flip ((`d;`c`b);
      	    (`c;enlist`b);
      	    (`e;`d`a);
      	    (`b;());
      	    (`a;()));

/ from http://nsl.com/papers/order.htm
k)order:{?|,/(?,/x@)\y}
k)!s
k)order[s;!s]

/ s:(`d`c`e`b`a)!(`c`b;enlist `b;`d`a;();())
order:{[d;k] distinct reverse raze { distinct raze x[y]}[d]\[k]}

order[s;key s]  / `b`c`a`d`e
