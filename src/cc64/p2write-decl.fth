
~ : (write-decl ( name val type -- )
     %function %l-value %pointer + +
     isn't? >r  %extern isn't? r> or
       IF 2drop drop exit THEN
     " extern " str!
     is-char? IF   " char "
              ELSE " int " THEN str!
     %function %l-value + isn't? >r
     %pointer is? r> and
       IF drop swap str! " [] /=" str! hex!
       ELSE %pointer is? IF ascii * fputc THEN
       %function is?
          IF %l-value isn't?
             IF rot str! ELSE " (*" str!
             rot str! ascii ) fputc THEN
          " ()" str! ELSE rot str! THEN
       %stdfctn is? IF "  *=" ELSE "  /=" THEN
       str!  drop hex! THEN
     "  ;" str!  cr! ;
