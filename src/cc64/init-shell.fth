
| Code c-charset
  (64 $cbfd jsr C)  (16 $f804 jsr C) 
   xyNext jmp end-code

| : c-charset-present?  ( -- f )
  (64 $cbf9 C) (16 $f800 C) 2@  $65021103. d= ;

| : init-shell  ( -- )
     only shell
     c-charset-present? IF c-charset THEN ;

' init-shell IS 'cold


| : .logo  ( -- )
     $e con!  \ switch to lowercase charset
     ."     running" cr
     .binary-name .version cr
     ." 2020 by Philip Zembrod" cr
     c-charset-present? not ?exit
     ." C charset in use" cr ;

' .logo IS 'restart
