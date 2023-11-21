f:{([]til 15000000)}

system "ts f[]"    / 65j, 134217984j 120 MB, which gets rounded up to a block of 128 MB.

system "ts f each til 15"    / 977j, 2013268016j, 15 times, we use 1920 MB.

system "ts raze f each til 15"    / 2364j, 4160753808j, The razed result is 1800 MB, which gets rounded up to a block of 2048 MB. However, since both the chunks and the result are temporarily in memory at the same time, our peak usage is 2048+1920=3968 MB

// Solution with globals
system "ts g:();{g,:f x} each til 15"    / 2200j, 2281702752j, Appending to a global is done in-place, so our peak usage is only 2048+128=2176 MB.


// Solution with undocumented behavior
/ doesn't append in-place, so every iteration copies the entire result set
system "ts {x,f y}/[();til 15]"    / 13271j, 4429186288j
system "ts {x,:f y;x}/[();til 15]"    / 12563j, 4429186288j

system "ts {z;x,:f y;x}/[();til 15;::]"     / 2273j, 2281702656j, adding a dummy third argument magically makes things fast

system "ts {r:();i:-1;do[count x;r,:f x i+:1];r} til 15"    / 2271j, 2281703008j, also achieve in-place appends without globals by writing out the loop in imperative style



f:{([] til 150000)}
// not append-in-place, every iteration copies entire result set
\ts raze l:f each til 15    / 43 65015408j
\ts {x,:f y;x }/[();til 15]    / 140 69207280j

// global, append-in-place
\ts g:(); {g,:f x} each til 15  / 5 52430496j

// undoc behavior
\ts {z;x,:f y;x}/[();til 15;::] / 12 52430016j
\ts {[x;y;z] x,:y; x}/[();f each til 15;::] / 8 81791488j
