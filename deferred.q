`::1235 ({`add  set x};{ 0N!"remote ",string .z.p; system "sleep 2"; 0N!"done ",string .z.p; x + y });

pending:()!();
reduceFunction:raze;

callback:{[clientHandle;result] 
 0N!"callback h ",-3!clientHandle;
 0N!"callback res ",-3!result;
 pending[clientHandle],:enlist result; / store the received result
 / check whether we have all expected results for this client
 if[count[workerHandles]=count pending clientHandle; 
   / test whether any response (0|1b;...) included an error
   isError:0<sum pending[clientHandle][;0]; 
   result:pending[clientHandle][;1]; / grab the error strings or results
   / send the first error or the reduced result
   r:$[isError;{first x where 10h=type each x};reduceFunction]result; 
     0N!"callback fin ",-3!r;
   -30!(clientHandle;isError;r); 
   pending[clientHandle]:(); / clear the temp results
 ]
 };

remoteFunction:{[clntHandle;query]
    neg[.z.w](`callback;clntHandle; @[{(0b;value x)};query;{(1b;x)}])
  };

workerHandles:hopen `::1235;

neg[workerHandles](remoteFunction;.z.w;(`add;1;20));
-30!(::);
0N!"done";

neg[workerHandles](remoteFunction;.z.w;(`add;1;`a));
-30!(::);
0N!"done";
