/ q -s 5

// https://github.com/KxSystems/ffi/tree/master
\l ffi.q

getThread:{`long$.ffi.cf[`syscall](186;::)};
mainThread:getThread[];

0N!-3!getThread[];  // same
{ 0N!-3!getThread[] } peach til 1;  // different
