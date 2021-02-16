
~ : (write-decl ( name val type -- )
     %function %reference %pointer + +
     isn't? >r  %extern isn't? r> or
       IF 2drop drop exit THEN
     " extern " str!
     is-char? IF   " char "
              ELSE " int " THEN str!
     %function %reference + isn't? >r
     %pointer is? r> and
       IF drop swap str! " [] /=" str! hex!
       ELSE %pointer is? IF ascii * fputc THEN
       %function is?
          IF %reference isn't?
             IF rot str! ELSE " (*" str!
             rot str! ascii ) fputc THEN
          " ()" str! ELSE rot str! THEN
       %stdfctn is? IF "  *=" ELSE "  /=" THEN
       str!  drop hex! THEN
     "  ;" str!  cr! ;
