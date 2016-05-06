l1:`x`y!(`a`b`c;`d`e);
l2:`a`b`e!(`aa`ab;`bb;`ee);
l3:`aa`ee!(`aaa;`eea`eeb);
l:((enlist `)!enlist key l1),l1,l2,l3;

allnodes:{[l;x]
    raze $[count c:raze l[x];c,.z.s[l;c];()]
   };
allleaves:{[l;x]
    raze $[count c:l[x];.z.s[l] each c;x]
   };
allnodes[l;`x]    // `a`b`c`aa`ab`bb`aaa
allleaves[l;`x]    // `aaa`ab`bb`c
