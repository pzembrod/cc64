
| : init-shell  ( -- )
     only shell ;

' init-shell IS 'cold


| : .logo  ( -- )
     $e con!  \ switch to lowercase charset
     ."     running" cr
     .binary-name .version cr
     ." 2022 by Philip Zembrod" cr
     c-charset-present?
       IF c-charset  ." C charset in use" cr THEN ;

' .logo IS 'restart
