\ *** Block No. 104, Hexblock 68

\ preprocessor loadscreen      20sep94pz

\ terminology / interface:

\  preprocess

  cr .( module preprocessor ) cr

\ The preprocessor is a really bad
\ hack which depends deeply on special
\ properties of input, scanner and
\ codegen.
\ It also implements #define through C constants.


\ *** Block No. 105, Hexblock 69

\   preprocessor:              11sep94pz

| : clearline ( -- )
     linebuf off res-inptr ;

| : cpp-error  ( -- )
     *preprocessor* error  clearline ;

| : check-eol  ( -- )
     skipblanks  char> 0=
        IF rdrop  cpp-error THEN ;

| : ?cpp-errorexit  ( flag -- )
       IF rdrop cpp-error THEN ;

| : ?cpp-fatal *preprocessor* ?fatal ;

| create include-name /filename allot

| create delim  1 allot


\ *** Block No. 106, Hexblock 6a

\   preprocessor:              11sep94pz

| : include ( -- )
     check-eol
     char> ascii < =
     char> ascii " =
     or not ?cpp-errorexit
     char> ascii < case? IF ascii > THEN
     delim c!  +char
     include-name 1+ 16 bounds
     DO char> 0= ?cpp-errorexit
        char> delim c@ =
           IF I include-name - 1-
           UNLOOP dup include-name c!
           0= ?cpp-errorexit
           include-name open-include
           exit THEN
     char> I c! +char LOOP
     BEGIN char> 0= ?cpp-errorexit
     char> +char delim c@ = UNTIL
     /filename 1- include-name c!
     include-name open-include ;


\ *** Block No. 107, Hexblock 6b

\   preprocessor:              19apr94pz

| variable minus

| : cpp-number? ( -- n false/ -- true )
     skipblanks
     char> num? 0= ?dup ?exit
     number drop  false ;

| : define ( -- )
     check-eol
     char> alpha? 0= ?cpp-errorexit
     get-id
     id-buf keyword?
        IF drop *preprocessor* error
        clearline  exit THEN
     char> bl - ?cpp-errorexit
     check-eol
     1  char> ascii - =
        IF negate +char THEN minus !
     cpp-number? ?cpp-errorexit
     minus @ *
     dup $ff00 and 0<> 1 and
     id-buf putglobal 2!  clearline ;


\ *** Block No. 108, Hexblock 6c

\   preprocessor:              19apr94pz

| create cpp-word 17 allot

| : cpp-nextword  ( -- adr )
     skipblanks
     cpp-word 1+ 16 bounds DO
     char> 0= char> bl = or
        IF I cpp-word - 1- cpp-word c!
        cpp-word UNLOOP exit THEN
     char> I c! +char LOOP
     BEGIN char> 0= char> bl = or 0=
     WHILE +char REPEAT
     16 cpp-word c!  cpp-word ;


\ *** Block No. 109, Hexblock 6d

\   preprocessor:              07may95pz

| : pragma  ( -- )
     cpp-nextword " cc64" strcmp
               0= ?cpp-errorexit
     cpp-number? ?cpp-fatal   >base !
     cpp-number? ?cpp-fatal   >zp   !
     cpp-number? ?cpp-fatal
     lib.first !
     cpp-number? ?cpp-fatal
     >runtime !
     cpp-number? ?cpp-fatal
     dup code.first !        *=
     cpp-number? ?cpp-fatal
     dup statics.libfirst !  >staticadr
     cpp-number? ?cpp-fatal
     statics.last !
     cpp-nextword dup c@ 0= ?cpp-fatal
     dup lib.codename strcpy
         lib.initname strcpy
     code.suffix lib.codename strcat
     init.suffix lib.initname strcat
     codelayout.ok   clearline ;


\ *** Block No. 110, Hexblock 6e

\   preprocessor:              07may95pz

| stringtab cpp-keywords

| x #define    x" define"
| x #include   x" include"
| x #pragma    x" pragma"

endtab

| create cpp-commands
 ' define ,  ' include ,  ' pragma ,


make preprocess ( -- )
   $pending @
      IF *preprocess-in-string* error
      clearline  exit THEN
   comment-state @ ?exit
   char> ascii # - ?exit  +char
   cpp-nextword cpp-keywords scanword
      IF 2* cpp-commands + perform
      exit THEN
   cpp-error ;
