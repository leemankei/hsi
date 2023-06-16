
days:80; base:10f; N:20; v:10; pool:base + asc N?v; 
d:{[f;x] @[x;where x > f x;:;f x] } f:avg;
f each (pool; days d/pool)
days d\pool
