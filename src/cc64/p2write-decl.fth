
~ : (write-decl ( name val type -- )
     %extern isn't? IF 2drop drop exit THEN
     %function %l-value %pointer + + isn't?
       IF drop " #define " str!  swap str! hex! cr! exit THEN
     " extern " str!
     %fastcall is? IF " _fastcall " str! THEN
     is-char? IF   " char "
              ELSE " int " THEN str!
     %function %l-value + isn't? >r
     %pointer is? r> and
       IF drop swap str! " [] *=" str! hex!
       ELSE %pointer is? IF ascii * fputc THEN
       %function is?
          IF %l-value isn't?
             IF rot str! ELSE " (*" str!
             rot str! ascii ) fputc THEN
          " ()" str! ELSE rot str! THEN
       "  *=" str!  drop hex! THEN
     "  ;" str!  cr! ;
