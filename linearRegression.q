l/ refer https://en.wikipedia.org/wiki/Simple_linear_regression
genLR:{[x;y]
    avgX:avg x; 
    avgY:avg y; 
    avgXY:avg x * y;
    dY:y - avgY; 
    dX:x - avgX; 
    sX:sum (x - avgX) xexp 2;
    m:sum dY * dX % sX; 
    c: avgY - m * avgX;
    {[m;c;x] c + m * x}[m;c]
    };

// train set
x:1.47 	1.50 	1.52 	1.55 	1.57 	1.60 	1.63 	1.65 	1.68 	1.70 	1.73 	1.75 	1.78 	1.80 	1.83 ;
y:52.21 	53.12 	54.48 	55.84 	57.20 	58.57 	59.93 	61.29 	63.11 	64.47 	66.28 	68.10 	69.92 	72.19 	74.46 ;

// get line formula
l:genLR[x;y]
// (slope;y-intercept)
value[l] 1 2

// test set
sY:l sX:1 + .01 * til 100;
([] sX; sY)
