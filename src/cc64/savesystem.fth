\ *** Block No. 8, Hexblock 8

\ savesystem                   12apr20pz

  cr .( savesystem ) cr

| : (savsys ( adr len -- )
 [ Assembler ] Next  [ Forth ]
 ['] pause  dup push  !  \ singletask
 i/o push  i/o off  bustype ;

~ : savesystem   \ name muss folgen
 save  dev 2 busopen  0 parse bustype
 " ,p,w" count bustype  busoff
 dev 2 busout  origin $17 -
 dup  $100 u/mod  swap bus! bus!
 here over - (savsys  busoff
 dev 2 busclose
 0 (drv ! derror? abort" save-error" ;
