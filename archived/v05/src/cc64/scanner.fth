\ *** Block No. 36, Hexblock 24

\ scanner: loadscreen          20sep94pz

\ terminology / interface:
\   nextword   backword
\   mark       advanced?
\   word.
\   start$     build$      end$
\   alle tokens
\   init-scanner

  cr .( module scanner ) cr


\ *** Block No. 37, Hexblock 25

\   scanner:                   26feb91pz

| : alpha?  ( c -- flag )
    dup  ascii a ascii [ uwithin
    over ascii A ascii { uwithin or  \ }
    swap ascii _ = or ;

| : num?  ( c -- flag )
    ascii 0  ascii :  uwithin ;

| : alphanum? ( c -- flag )
    dup alpha?  swap num?  or ;

| : skipblanks  ( -- )
     BEGIN char> bl = WHILE
     +char REPEAT ;

~ 0 constant #char#
~ 1 constant #id#
~ 2 constant #number#
~ 3 constant #keyword#
~ 4 constant #oper#
~ 5 constant #string#
~ -1 dup 2constant #eof#


\ *** Block No. 38, Hexblock 26

\   scanner:                   12jan91pz

| stringtab keyword

~ x <auto>     x" auto"
~ x <break>    x" break"
~ x <case>     x" case"
~ x <char>     x" char"
~ x <cont>     x" continue"
~ x <default>  x" default"
~ x <do>       x" do"
~ x <else>     x" else"
~ x <extern>   x" extern"
~ x <for>      x" for"
~ x <goto>     x" goto"
~ x <if>       x" if"
~ x <int>      x" int"
~ x <register> x" register"
~ x <return>   x" return"
~ x <static>   x" static"
~ x <switch>   x" switch"
~ x <while>    x" while"

  endtab


\ *** Block No. 39, Hexblock 27

\   scanner:                   18apr94pz

| variable token

~ : scanword  ( adr table -- false )
            ( adr table -- token true )
     token off
     BEGIN ?dup WHILE
     2dup >string strcmp
        IF 2drop token @ true exit THEN
     +string  1 token +! REPEAT
     drop false ;

~ : keyword?  ( adr -- false )
              ( adr -- token true )
     keyword  scanword ;


\ *** Block No. 40, Hexblock 28

\   scanner:                   18apr94pz

| create id-buf  /id 1+ allot

| : get-id ( -- )
     id-buf 1+ /id bounds
     DO char> I c! +char char>
     alphanum? 0=
        IF I id-buf - id-buf c!
        UNLOOP exit THEN
     LOOP /id id-buf c!
     BEGIN +char char>
     alphanum? 0= UNTIL ;

| : id ( -- word type )
     get-id  id-buf keyword?
        IF #keyword#
        ELSE id-buf #id# THEN ;


\ *** Block No. 41, Hexblock 29

\   scanner:                   08oct90pz

| create operator-list
 ," +++---**///%%&&&|||^^!!==<<<<>>>>~"
 ," += -= = =* = =& =| = = = <<= >>=  "
 ,"                          =   =    "

| stringtab op
  ?head off  ~  ?head @ 34 * ?head !
  x <++>    x <+=>    x <+>
  x <-->    x <-=>    x <->
  x <*=>    x <*>
  x </=>    x <comment>         x </>
  x <%=>    x <%>
  x <and=>  x <l-and> x <and>
  x <or=>   x <l-or>  x <or>
  x <xor=>  x <xor>
  x <!=>    x <!>
  x <==>    x <=>
  x <<<=>   x <<<>    x <<=>    x <<>
  x <>>=>   x <>>>    x <>=>    x <>>
  x <inv>

  endtab


\ *** Block No. 42, Hexblock 2a

\   scanner:                   08oct90pz

| : operator?  ( c -- token t/ -- f )
     operator-list count 0
     DO 2dup I + c@ =
       IF 2drop  +char
       I true UNLOOP exit THEN
     LOOP  2drop false ;

| : th-char ( token1 n -- token2 )
     operator-list swap 1
        DO count + LOOP count rot
        DO dup I + c@  dup  bl =
           IF 2drop
           I UNLOOP exit THEN
        char> =
           IF drop +char
           I UNLOOP exit THEN
        LOOP  *compiler* fatal ;

| : operator ( token1 -- token2 #op# )
     2 th-char  3 th-char  #oper# ;


\ *** Block No. 43, Hexblock 2b

\   scanner:                   13feb91pz

| : octnum ( -- n )
     0 BEGIN char> ascii 0 -
     dup 8 u< WHILE
     swap 8 * +  +char REPEAT drop ;

| : deznum ( -- n )
     0 BEGIN char> ascii 0 -
     dup 10 u< WHILE
     swap 10 * +  +char REPEAT drop ;

| : hexdigit ( c -- n/-1 )
     capital  ascii 0 -
     dup 10 u< ?exit
     [ ascii A ascii 0 - ] literal -
     dup 6 u< IF 10 +
              ELSE drop -1 THEN ;

| : hexnum ( -- n )
     0 BEGIN char> hexdigit
     dup 16 u< WHILE
     swap 16 * +  +char REPEAT drop ;


\ *** Block No. 44, Hexblock 2c

\   scanner:                   03oct90pz

| : number ( -- n #number# )
     char> ascii 0 =
        IF +char char> capital
        ascii X = IF +char hexnum
                  ELSE octnum THEN
        ELSE deznum THEN #number# ;


| create charlist ," ()[]{},;:"

| : legalchar? ( c -- c true  )
               ( c --   false )
     charlist count bounds
     DO dup I c@ =
        IF UNLOOP true exit THEN
     LOOP drop *lex* error false ;


\ *** Block No. 45, Hexblock 2d

\   scanner:                   02mar94pz

| create \list ," btnfr0\' "
  ascii " here 1- c!
  8 c, 9 c, 13 c, 12 c, 13 c, 0 c,
  ascii \ c,  ascii ' c,  ascii " c,

| 256 constant none

| : \char ( -- c )
     char> 0= IF newline none exit THEN
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

| 512 constant err

| : char-const ( -- c #number# )
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

| variable do$
| : $: Create c,
       Does> c@ do$ @ + perform ;

| 0 $: $[  ( -- sys )
| 2 $: $,  ( c -- )
| 4 $: ]$  ( sys -- desc )

| variable $pending

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

| : string ( -- ??? #string# )
     $pending on  0 #string# ;


| : (nextword ( -- word type )
     $pending @  *compiler* ?fatal
     BEGIN
      BEGIN skipblanks  char> 0=
      eof @ 0= and WHILE newline REPEAT
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

| : is-comment? ( w t -- w t flag )
     2dup <comment> #oper# dnegate d+
     or 0= ;

| ' comment-state ALIAS st

| : skip-comment ( -- )
     line @ comment-line !
     2 st !
     BEGIN char> +char ascii * case?
        IF 1 st !
        ELSE ascii / case?
           IF st @ 1 = IF st off
                       ELSE 2 st ! THEN
           ELSE 2 st ! 0=
              IF newline THEN THEN THEN
     st @ 0= UNTIL ;


\ *** Block No. 50, Hexblock 32

\   scanner:                   11mar91pz

| 2variable word'
| variable back
| variable word#

~ : nextword ( -- word type )
     back @ back off  IF word' 2@ ELSE
      BEGIN (nextword is-comment? WHILE
      2drop skip-comment REPEAT
      2dup word' 2! THEN
     1 word# +! ;

~ : backword ( -- )
     back @ *compiler* ?fatal
     back on  -1 word# +! ;

~ : mark ( -- word# )  word# @ ;

~ : advanced? ( word# -- flag )
     word# @ = 0= ;

~ : init-scanner
   back off  $pending off  word# off ;
    init: init-scanner


\ *** Block No. 51, Hexblock 33

\   scanner: word.             03oct90pz

| : keyword. ( n )
     keyword swap string[]
     >string count type ;

| : emit' ( c ) dup bl -
          IF emit ELSE drop THEN ;
| : oper. ( n )  operator-list 2dup
       1+ + c@ emit    count + 2dup
       1+ + c@ emit'   count +
       1+ + c@ emit' ;

~ : word.  ( n typ )
  #keyword# case? IF keyword. exit THEN
  #oper#    case? IF oper.    exit THEN
  #number#  case? IF .        exit THEN
  #char#    case? IF emit     exit THEN
  #id#      case? IF count type
                              exit THEN
  #string#  case? IF ." string @ " u.
                              exit THEN
  ." word t:" . ." n:" . ;
