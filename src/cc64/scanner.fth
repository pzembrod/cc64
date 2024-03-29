\ *** Block No. 36, Hexblock 24

\ scanner: loadscreen          20sep94pz

\ terminology / interface:
\   nextword   backword
\   mark       advanced?
\   word.
\   start$     build$      end$     do$
\   alle tokens
\   ( init-scanner )

\ *** Block No. 37, Hexblock 25

\   scanner:                   26feb91pz

\prof profiler-bucket [scanner-alphanum]

|| : skipblanks  ( -- )
     BEGIN char> bl = WHILE
     +char REPEAT ;

\prof [scanner-alphanum] end-bucket
\prof profiler-bucket [scanner-keyword]

~ 0 constant #char#
~ 1 constant #id#
~ 2 constant #number#
~ 3 constant #keyword#
~ 4 constant #oper#
~ 5 constant #string#
~ : #eof#  -1 dup ;


\ *** Block No. 38, Hexblock 26

\   scanner:                   12jan91pz

|| 19 string-tab keywords

~ x <do>       x" do"
~ x <if>       x" if"
~ x <for>      x" for"
~ x <int>      x" int"
~ x <auto>     x" auto"
~ x <case>     x" case"
~ x <char>     x" char"
~ x <else>     x" else"
~ x <goto>     x" goto"
~ x <break>    x" break"
~ x <while>    x" while"
~ x <extern>   x" extern"
~ x <return>   x" return"
~ x <static>   x" static"
~ x <switch>   x" switch"
~ x <default>  x" default"
~ x <cont>     x" continue"
~ x <register> x" register"
~ x <fastcall> x" _fastcall"

end-tab

|| keywords 2 9 length-index keywords-index
  <do> idx,
  <for> idx,
  <auto> idx,
  <break> idx,
  <extern> idx,
  <default> idx,
  <cont> idx,
  <fastcall> idx,
end-index

\ *** Block No. 39, Hexblock 27

\   scanner:                   18apr94pz

|| : keyword?  ( adr -- false )
               ( adr -- token true )
     keywords-index  find-via-index ;


\ *** Block No. 40, Hexblock 28

\   scanner:                   18apr94pz

\prof [scanner-keyword] end-bucket
\prof profiler-bucket [scanner-identifier]

|| create id-buf  /id 1+ allot

|| : get-id ( -- )
     id-buf 1+ /id bounds
     DO char> I c! +char char>
     alphanum? 0=
        IF I id-buf - id-buf c!
        UNLOOP exit THEN
     LOOP /id id-buf c!
     BEGIN +char char>
     alphanum? 0= UNTIL ;

|| : id ( -- tokenvalue token )
     get-id  id-buf keyword?
        IF #keyword#
        ELSE id-buf #id# THEN ;


\ *** Block No. 41, Hexblock 29

\   scanner:                   08oct90pz

\prof [scanner-identifier] end-bucket
\prof profiler-bucket [scanner-operator]

here ," +++---**///%%&&&|||^^!!==<<<<>>>>~" 1+ || constant oper-1st-ch
here ," += -= = =* = =& =| = = = <<= >>=  " 1+ || constant oper-2nd-ch
here ,"                          =   =    " 1+ || constant oper-3rd-ch

enum
  ~on
  y <++>    y <+=>    y <+>
  y <-->    y <-=>    y <->
  y <*=>    y <*>
  y </=>    y <comment>         y </>
  y <%=>    y <%>
  y <and=>  y <l-and> y <and>
  y <or=>   y <l-or>  y <or>
  y <xor=>  y <xor>
  y <!=>    y <!>
  y <==>    y <=>
  y <<<=>   y <<<>    y <<=>    y <<>
  y <>>=>   y <>>>    y <>=>    y <>>
  y <inv>
  ~off
end-enum


\ *** Block No. 42, Hexblock 2a

\   scanner:                   08oct90pz

|| create $2?-tab
  $ff    c,  <!=>   c,  $ff    c,  $ff    c,
  $ff    c,  <%=>   c,  <and=> c,  $ff    c,
  $ff    c,  $ff    c,  <*=>   c,  <++>   c,
  $ff    c,  <-->   c,  $ff    c,  </=>   c,

|| : $2?-oper?  ( c -- tokenvalue t / c -- f )
     $0f and $2?-tab + c@ dup $ff = IF drop false ELSE +char true THEN ;

|| create $?c-tab
  <<<=>  c,  <==>   c,  <>>=>  c,  $ff    c,
  $ff    c,  $ff    c,  <xor=> c,  $ff    c,
  <or=>  c,  $ff    c,  <inv>  c,  $ff    c,

|| : $?c-oper?  ( c -- tokenvalue t / c -- f )
     dup 3 and swap $e0 and $20 -
     dup $20 > IF $a0 - IF drop false exit THEN $40 THEN 2/ 2/ 2/ +
     $?c-tab + c@ dup $ff = IF drop false ELSE +char true THEN ;

|| : operator?  ( c -- tokenvalue t / c -- f )
     dup $f0 and $20 = IF $2?-oper? exit THEN
     dup $1f and $1b > IF $?c-oper? exit THEN
     drop false ;

|| : c@-bl=-if-#oper#-exit
       ( tokenvalue ptr> -- tokenvalue chr / -- tokenvalue #oper# )
     c@ dup bl = IF drop #oper# rdrop exit THEN ;

|| : limit-oper-loop  ( n -- n )
     dup <inv> > *compiler* ?fatal ;

|| : operator ( tokenvalue1 -- tokenvalue2 #op# )
     BEGIN dup oper-2nd-ch + c@-bl=-if-#oper#-exit
     char> - WHILE 1+ limit-oper-loop REPEAT +char
     BEGIN dup oper-3rd-ch + c@-bl=-if-#oper#-exit
     char> - WHILE 1+ limit-oper-loop REPEAT +char #oper# ;

\prof [scanner-operator] end-bucket
\prof profiler-bucket [scanner-number]

\ *** Block No. 43, Hexblock 2b

\   scanner:                   13feb91pz

|| : octnum ( -- n )
     0 BEGIN char> ascii 0 -
     dup 8 u< WHILE
     swap 8 * +  +char REPEAT drop ;

|| : deznum ( -- n )
     0 BEGIN char> ascii 0 -
     dup 10 u< WHILE
     swap 10 * +  +char REPEAT drop ;

|| : hexdigit ( c -- n/-1 )
     capital  ascii 0 -
     dup 10 u< ?exit
     [ ascii A ascii 0 - ] literal -
     dup 6 u< IF 10 +
              ELSE drop -1 THEN ;

|| : hexnum ( -- n )
     0 BEGIN char> hexdigit
     dup 16 u< WHILE
     swap 16 * +  +char REPEAT drop ;


\ *** Block No. 44, Hexblock 2c

\   scanner:                   03oct90pz

|| : number ( -- n #number# )
     char> ascii 0 =
        IF +char char> capital
        ascii X = IF +char hexnum
                  ELSE octnum THEN
        ELSE deznum THEN #number# ;

\prof [scanner-number] end-bucket
\prof profiler-bucket [scanner-char/string]

|| create charlist ," ()[]{},;:?"

|| : legalchar? ( c -- c true  )
               ( c --   false )
     charlist count bounds
     DO dup I c@ =
        IF UNLOOP true exit THEN
     LOOP drop *lex* error false ;


\ *** Block No. 45, Hexblock 2d

\   scanner:                   02mar94pz

|| create \list ," btnfr0\' "
  ascii " here 1- c!
  8 c, 9 c, 13 c, 12 c, 13 c, 0 c,
  ascii \ c,  ascii ' c,  ascii " c,

|| 256 constant none

|| : \char ( -- c )
     char> 0= IF nextline none exit THEN
     \list count bounds
     DO I c@ char> =
        IF +char I \list c@ + c@
        UNLOOP exit THEN
     LOOP
     char> ascii 1 ascii 8 uwithin
        IF 0  3 0 DO char> ascii 0 -
        7 over u< IF drop LEAVE THEN
        swap 8 * +  +char LOOP  255 and
        ELSE none THEN ;


\ *** Block No. 46, Hexblock 2e

\   scanner:                   03oct90pz

|| 512 constant err

|| : char-const ( -- c #number# )
     BEGIN char> 0 case?
        IF *eol* error err
        ELSE +char ascii ' case?
           IF *lex* error err
           ELSE ascii \ case?
              IF \char THEN THEN THEN
     dup none - UNTIL
     dup err -
       IF char> ascii ' =
         IF +char ELSE *lex* error THEN
       THEN
     255 and #number# ;


\ *** Block No. 47, Hexblock 2f

\   scanner:                   21feb91pz

|| variable do$
| : $: Create c,
       Does> c@ do$ @ + perform ;

|| 0 $: $[  ( -- sys )
|| 2 $: $,  ( c -- )
|| 4 $: ]$  ( sys -- desc )

|| variable $pending

~ : do$:  Create:
    Does> ( pfa -- desc )  do$ !
     $pending @ 0= *compiler* ?fatal
     $[ BEGIN char> 0= *eol* ?error
     char> WHILE char> ascii " - WHILE
     char> +char ascii \ case?
        IF \char THEN
     dup none =
        IF drop ELSE 255 and $, THEN
     REPEAT
     char> IF +char THEN
     0 $,  ]$  $pending off ;


\ *** Block No. 48, Hexblock 30

\   scanner:                   14sep94pz

|| : string ( -- ??? #string# )
     $pending on  0 #string# ;

\prof [scanner-char/string] end-bucket
\prof profiler-bucket [scanner-(nextword]

|| : (nextword ( -- tokenvalue token )
     $pending @  *compiler* ?fatal
     BEGIN
      BEGIN skipblanks  char> 0=
      eof @ 0= and WHILE nextline REPEAT
     eof @ #eof = IF #eof#  exit THEN
     char> alpha? IF id exit THEN
     char> num?   IF number exit THEN
     char> operator?
                  IF operator exit THEN
     char> ascii " =
        IF +char string exit THEN
     char> ascii ' =
        IF +char char-const exit THEN
     char> +char legalchar? UNTIL
     #char# ;


\ *** Block No. 49, Hexblock 31

\   scanner:                   09oct90pz

\prof [scanner-(nextword] end-bucket
\prof profiler-bucket [scanner-comment]

|| : is-comment? ( w t -- w t flag )
     2dup <comment> #oper# dnegate d+
     or 0= ;

|| ' comment-state ALIAS st

|| : skip-comment ( -- )
     line @ comment-line !
     2 st !
     BEGIN char> +char ascii * case?
        IF 1 st !
        ELSE ascii / case?
           IF st @ 1 = IF st off
                       ELSE 2 st ! THEN
           ELSE 2 st ! 0=
              IF nextline THEN THEN THEN
     st @ 0= UNTIL ;


\ *** Block No. 50, Hexblock 32

\   scanner:                   11mar91pz

\prof [scanner-comment] end-bucket
\prof profiler-bucket [scanner-nextword]

\prof profiler-bucket [scanner-nextword-vars]

|| create word'  4 allot
|| variable word#

\prof [scanner-nextword-vars] end-bucket
\prof profiler-bucket [scanner-fetchword]

~ : fetchword ( -- tokenvalue token )
     BEGIN (nextword is-comment? WHILE
     2drop skip-comment REPEAT \ ."  fetchword: " 2dup u. u.
     word' 2! ;

~ : accept ( -- )
     1 word# +!  fetchword ;

\prof [scanner-fetchword] end-bucket
\prof profiler-bucket [scanner-thisword]

~ : thisword ( -- tokenvalue token )  word' 2@ ;

\prof [scanner-thisword] end-bucket
\prof profiler-bucket [scanner-nextword-mark]

~ : mark ( -- word# )  word# @ ;

\prof [scanner-nextword-mark] end-bucket
\prof profiler-bucket [scanner-nextword-advanced?]

~ : advanced? ( word# -- flag )
     word# @ = 0= ;

\prof [scanner-nextword-advanced?] end-bucket

\prof [scanner-nextword] end-bucket
\prof profiler-bucket [scanner-rest]

|| : init-scanner
   $pending off  word# off ;
    init: init-scanner


\ *** Block No. 51, Hexblock 33

\   scanner: word.             03oct90pz

|| : keyword. ( tokenvalue )
     keywords swap string[]
     >string count type ;

|| : emit' ( char ) dup bl -
          IF emit ELSE drop THEN ;

|| : oper. ( tokenvalue )
     dup oper-1st-ch + c@ emit
     dup oper-2nd-ch + c@ emit'
         oper-3rd-ch + c@ emit' ;

~ : word.  ( tokenvalue token )
  #keyword# case? IF keyword. exit THEN
  #oper#    case? IF oper.    exit THEN
  #number#  case? IF .        exit THEN
  #char#    case? IF emit     exit THEN
  #id#      case? IF count type
                              exit THEN
  #string#  case? IF ." string @ " u.
                              exit THEN
  ." token/val:" . . ;

\prof [scanner-rest] end-bucket
