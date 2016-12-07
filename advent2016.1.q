steps:"R4, R1, L2, R1, L1, L1, R1, L5, R1, R5, L2, R3, L3, L4, R4, R4, R3, L5, L1, R5, R3, L4, R1, R5, L1, R3, L2, R3, R1, L4, L1, R1, L1, L5, R1, L2, R2, L3, L5, R1, R5, L1, R188, L3, R2, R52, R5, L3, R79, L1, R5, R186, R2, R1, L3, L5, L2, R2, R4, R5, R5, L5, L4, R5, R3, L4, R4, L4, L4, R5, L4, L3, L1, L4, R1, R2, L5, R3, L4, R3, L3, L5, R1, R1, L3, R2, R1, R2, R2, L4, R5, R1, R3, R2, L2, L2, L1, R2, L1, L3, R5, R1, R4, R5, R2, R2, R4, R4, R1, L3, R4, L2, R2, R1, R3, L5, R5, R2, R5, L1, R2, R4, L1, R5, L3, L3, R1, L4, R2, L2, R1, L1, R4, R3, L2, L3, R3, L2, R1, L4, R5, L1, R5, L2, L1, L5, L2, L5, L2, L4, L2, R3" except " ";

s:"," vs steps;
c:`$/:s[;0];
d:"I"$1_/:s;
s:c,'d;
s:s,'count[s]#`x`y;

path:{[x;y]
    nextDir:{[now;move] d mod[@[`L`R!-1 1;move] + first where d = now;count d:`N`E`S`W] };
    m:`N`E`S`W!(1 0; 0 1;-1 0;0 -1);
    (x[0] + m[x 1] * y[1] * (`L`R!-1 1)@y[0]; nextDir[x[1];y[0]])
}\[(0 0;`N);s];

sum abs last[path][0]
