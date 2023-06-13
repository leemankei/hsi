`::1235 ({`add  set x};{ 0N!"remote ",string .z.p; system "sleep 2"; 0N!"done ",string .z.p; x + y });
`::1235 ({`join set x};{ 0N!"remote ",string .z.p; system "sleep 2"; 0N!"done ",string .z.p; x , y });

pending:()!();
reduceFunction:raze;

callback:{[clientHandle;result;guid] 
 0N!"callback h ",-3!clientHandle;
 0N!"callback guid ",-3!guid;
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
    .qrys[guid;`res]:r;
   -30!(clientHandle;isError;r); 
   pending[clientHandle]:(); / clear the temp results
 ]
 };


.qrys:()!();
remoteCall:{[workerHandles;qry] 
    guid:first 1?0Ng;
    .qrys[guid]:`reqTime`qry`res!(.z.p;qry;());
    remoteFunction:{[callerHandle;query;guid]
        res:@[{(0b;value x)};query;{(1b;x)}];
        0N!-3!(system"p";res);
        neg[.z.w](`callback;callerHandle; res;guid)
      };
    0N!"call ",-3!(guid;qry);
    neg[workerHandles](remoteFunction;.z.w;qry;guid);
    -30!(::);
    0N!"remoteCalled ",-3!guid;
    };

workerHandles:hopen `::1235;

// hang if call all 3 together
remoteCall[workerHandles;(`add;1;2)];
remoteCall[workerHandles;(`join;"asdf";"dfg")];
remoteCall[workerHandles;(`add;1;3)];    // if called before prev completed, 'Handle was not expecting a response msg

.qrys
