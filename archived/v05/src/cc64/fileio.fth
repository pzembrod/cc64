\ *** Block No. 112, Hexblock 70

\ file-i/o                     20sep94pz

  cr .( module file-i/o ) cr


\ *** Block No. 113, Hexblock 71

\   file-i/o                   21sep94pz

~ : fhandle  create 6 allot ;

~ : set-fhandle  ( dev 2nd handle -- )
     dup off  2+ 2! ;

| variable >handle
| : handle  >handle @ ;
~ -1 constant #eof

~ : feof?  ( handle -- flag ) @ ;


\ ~ variable fdelay  10 fdelay !

\ | : fwait  ( -- )
\      fdelay @ 0 ?DO
\      $00a1 @ BEGIN dup $00a1 @ - UNTIL
\      drop LOOP ;


\ *** Block No. 114, Hexblock 72

\   file-i/o                   21sep94pz

| : fopen  ( mode type name handle -- )
     dup off
     2+ 2@ busopen  count bustype
     ascii , bus!  bus!
     ascii , bus!  bus!  busoff ;

| : fclose  ( handle -- )
     2+ 2@ busclose ;

| : fsetin  ( handle -- )
     dup >handle ! 2+ 2@ busin ;

| : fsetout  ( handle -- )
     dup >handle ! 2+ 2@ busout ;

| ' busoff ALIAS funset  ( -- )


\ *** Block No. 115, Hexblock 73

\   file-i/o                   13sep94pz

| : fgetc  ( -- c )
     handle @ IF #eof ELSE bus@
            i/o-status? handle ! THEN ;

| : fgets  ( adr n -- n' )
     handle @ IF 2drop 0 exit THEN
     0 -rot bounds  ?DO bus@ I c! 1+
     i/o-status? IF LEAVE THEN  LOOP
     i/o-status? handle ! ;

| : fget2delim ( adr n delim -- n' f )
     handle @ IF 2drop drop 0. exit THEN
     -rot 0 -rot bounds
     DO 1-  over bus@ under =
        IF drop negate LEAVE THEN
     I c!   i/o-status?
        IF negate LEAVE THEN  LOOP
     dup 0<
        IF BEGIN 1- over bus@ - WHILE
        i/o-status? UNTIL negate nip -1
        ELSE nip 0 THEN
     i/o-status? handle ! ;


\ *** Block No. 116, Hexblock 74

\   file-i/o                   11sep94pz

| : fskip  ( n -- )
     handle @ IF drop exit THEN
     0 ?DO bus@ drop i/o-status?
        IF LEAVE THEN   LOOP
     i/o-status? handle ! ;


| ' bus! ALIAS fputc  ( c -- )

| ' bustype ALIAS fputs  ( adr n -- )
