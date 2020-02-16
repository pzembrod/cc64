
\ *** Block No. 0, Hexblock 0

\ c-compiler (1)               11sep94pz

.                    0
..                   0
loadscreen          &2

DIR: tools          &5

memman             &12
listman            &18
errormessages      &24
input              &30
scanner            &36
errorhandler       &54
symboltable        &60
savestack          &66
codehandler        &72
codeoutput         &77
fileman            &78
assembler          &84
preprocessor      &104
fileio            &112
forth-assembler   &120
DIR: test         &149


\ *** Block No. 1, Hexblock 1

\ relocating the system        23aug94pz

| : relocate-tasks  ( newUP -- )
 up@ dup
 BEGIN  1+ under @ 2dup -
 WHILE  rot drop  REPEAT  2drop ! ;

: relocate  ( stacklen rstacklen -- )
 swap  origin +
 2dup + b/buf + 2+  limit u>
  abort" buffers?"
 dup   pad  $100 +  u< abort" stack?"
 over  udp @ $40 +  u< abort" rstack?"
 flush empty
 under  +   origin $A + !        \ r0
 dup relocate-tasks
 up@ 1+ @   origin   1+ !        \ task
       6 -  origin  8 + ! cold ; \ s0

: bytes.more  ( n -- )
 up@ origin -  +  r0 @ up@ - relocate ;
: buffers  ( +n -- )
 b/buf * 2+  limit r0 @ -
 swap - bytes.more ;
  $d000 ' limit >body !  1 buffers

\ *** Block No. 2, Hexblock 2

\ development loadscreen 1     21sep94pz

  onlyforth  decimal
  : ~   ;          : ||  | ;
  root   cd tools
  ^ unloop  ^ doer-make thru

  vocabulary compiler
  compiler also definitions   : | ;
  ^ stringtab  ^ remove-inits thru root
  ^ errormessages     load
  ^ errorhandler      load
  ^ memman            load
  ^ listman           load
  ^ fileio            load
  ^ fileman           load
  ^ input             load
  ^ scanner           load
  ^ symboltable       load
  ^ codehandler       load
  ^ codeoutput        load
  ^ assembler         load
  ^ preprocessor      load



\ *** Block No. 3, Hexblock 3

\ testing loadscreen 1         21sep94pz

  onlyforth  decimal
| : ~   ;    ' noop IS .status
  6 8 thru   \ unloop strcmp doer-make
\ 120 load    \ transient assembler
 129 load    \ 2@ 2! 2variable/constant
  vocabulary compiler
  compiler also definitions    : |  ;
  9 10 thru  \ strtab init
  24 load    \ errormessages
  54 load    \ errorhandler
  12 load    \ memman
  18 load    \ listman
 112 load    \ fileio
  78 load    \ fileman
  30 load    \ input
  36 load    \ scanner
  60 load    \ symboltable
  72 load    \ codehandler
  77 load    \ codeoutput
  84 load    \ assembler
 104 load    \ preprocessor



\ *** Block No. 4, Hexblock 4

\ endcompile  loadscreen 1     21sep94pz

  onlyforth  decimal  cr
| : ~  | ;
  6 8 thru   \ unloop strcmp doer-make
 120 load    \ transient assembler
 129 load    \ 2@ 2! 2variable/constant
  vocabulary compiler
  compiler also definitions
  9 10 thru  \ strtab init
  24 load    \ errormessages
  54 load    \ errorhandler
  12 load    \ memman
  18 load    \ listman
 112 load    \ fileio
  78 load    \ fileman
  30 load    \ input
  36 load    \ scanner
  60 load    \ symboltable
  72 load    \ codehandler
  77 load    \ codeoutput
  84 load    \ assembler
 104 load    \ preprocessor



\ *** Block No. 5, Hexblock 5

\ tools:                       18apr94pz

..                  -5
unloop               1
strcmp               2
doer-make            3
stringtab            4
init                 5
remove-inits         6

















\ *** Block No. 6, Hexblock 6

\ do-loop tools                26may91pz

\needs unloop                         (
\ ) : unloop  r> rdrop rdrop rdrop >r ;

  : >I  ( n -- )
    r> rdrop swap r@ - >r >r ;


  : >lo/hi ( u -- lo hi )
     256 u/mod ;

  : lo/hi> ( lo hi -- u )
     255 and 256 * swap 255 and + ;

  : >lo ( -- lo )
     255 and ;
  : >hi ( -- hi )
     2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ ;

\needs :does>                         (
\ ) : :does>  here >r [compile] does> (
\ )   current @ context !  hide 0 ] ;



\ *** Block No. 7, Hexblock 7

\ strcmp                       09may94pz

~ : strcmp  ( str1 str2 -- flag )
   count rot count rot over =
      IF 0 ?DO
      over I + c@  over I + c@ -
        IF 2drop false UNLOOP exit THEN
      LOOP 2drop true
      ELSE drop 2drop false THEN ;

~ : strcpy  ( src dst -- )
     over c@ 1+ move ;

~ : strcat  ( src dst -- )
     swap count >r over count + r@ move
     dup c@ r> + swap c! ;










\ *** Block No. 8, Hexblock 8

\ doer/make (interaktiv)       02sep94pz

  here 0 ] ;
  : doer  ( -- )
      create  [ swap ] literal ,
      does> @ [ assembler ] ip
              [ forth ]     ! ;

  : make  ( -- )
      here ' >body ! [compile] ] 0 ;
















\ *** Block No. 9, Hexblock 9

\ stringtabellen               30sep90pz

| variable n
| variable m

~ : x ( -- )  n @  1 n +!  constant ;
~ : x"  ( -- )   here m @ !  here m !
    2 allot  [compile] ," ;

  here 0 ,   | constant nil
  here nil , ," end of table"
             | constant void

~ : stringtab ( -- )
     create  here m !  2 allot  0 n !
    does> ( -- 1.adr )  @ ;
~ : endtab ( -- )  nil m @ ! ;

~ : >string  ( adr -- str )  2+ ;
~ : +string  ( adr1 -- adr2/0 ) @ ;
~ : string[] ( tab n -- adr )
     0 ?DO +string ?dup 0= IF void THEN
    LOOP ;



\ *** Block No. 10, Hexblock a

\ init                         18apr94pz

| variable inits  inits off

~ : init  ( -- )
     inits BEGIN @ ?dup WHILE
           dup 2+ perform REPEAT ;

~ : init: ( name )
     inits BEGIN dup @ WHILE @ REPEAT
     here swap !  0 ,  ' , ;















\ *** Block No. 11, Hexblock b

\   init                       18apr94pz

  : remove-inits
    ( dict symb -- dict symb )
     inits BEGIN dup @ WHILE
           2 pick over @ u<
              IF dup off ELSE @ THEN
           REPEAT drop ;

  : inits?
   inits BEGIN @ ?dup WHILE dup 2+ @
   >name count $1f and cr type REPEAT ;

' remove-inits IS custom-remove

\\
~ ' ; ALIAS ;init...
      immediate restrict

~ : ...init:
     inits BEGIN dup @ WHILE @ REPEAT
     here swap !  0 ,
     here 2+ ,
     [ ' init: @ ] literal ,  \ nest
     ] 0 ;

\ *** Block No. 12, Hexblock c

\ memman: loadscreen           20sep94pz

  .( module memman ) cr

 1 5 +thru

\\ terminologie:
   himem
   heap[    ]heap
   hash[    ]hash
   symtab[  ]symtab
   static[  ]static
   code[    ]code
   linebuf

   /linebuf
   #globals
   /link
   /symbol
   /id

   init-mem

   .mem


\ *** Block No. 13, Hexblock d

\   memman: variable           03sep94pz

| create mem  $d000 , 100   ,
              1000  , 4000  , 4000 ,
              0 , 0 , 0 , 0 , 0 ,

  : himem         mem @ ;
| : #links        mem 2+ @ ;
~ : #globals      mem 4 + @ ;
| : symtabsize    mem 6 + @ ;
| : codesize      mem 8 + @ ;
  : lomem          r0 @ ;

~ 6 constant /link   \ listenknoten

~ 4 constant /symbol \ datenfeldgroesse

~ 31 constant /id  \ darf nicht kleiner
   \ als das kuerzeste keyword sein !!!

~ 133 constant /linebuf





\ *** Block No. 14, Hexblock e

\   memman: configure          03sep94pz

~ ' himem ALIAS   ]heap
~               : heap[    mem 10 + @ ;
~ ' heap[ ALIAS   ]hash
~               : hash[    mem 12 + @ ;
~ ' hash[ ALIAS   ]symtab
~               : symtab[  mem 14 + @ ;
~ ' symtab[ ALIAS ]code
~               : code[    mem 16 + @ ;
~ ' code[ ALIAS   ]static
~               : static[  mem 18 + @ ;
~ ' lomem ALIAS   linebuf

| : (conf?  ( -- flag )
     himem  #links /link *  -
                      dup mem 10 + !
     #globals 2*  -   dup mem 12 + !
     symtabsize -     dup mem 14 + !
     codesize   -         mem 16 + !
     linebuf /linebuf +   mem 18 + !
     static[ 11 + ]static u> ;




\ *** Block No. 15, Hexblock f

\   memman: .mem               24aug94pz

~ : configure  ( -- )
     (conf?   *memsetup* ?fatal ;

   init: configure

| : set-mem:  ( n -- ) create c, does>
  ( n dfa -- ) c@ mem + ! ;

~ 0 set-mem: himem!
~ 2 set-mem: #links!
~ 4 set-mem: #globals!
~ 6 set-mem: symtabsize!
~ 8 set-mem: codesize!

\\

| create (default-mem  $d000 , $20   ,
               $10   , $100  , $100  ,

~ : default-mem  ( -- )
  (default-mem mem 10 cmove configure ;



\ *** Block No. 16, Hexblock 10

\   memman:                    09sep94pz

| : .bytes  ( n -- )  . ." bytes" cr ;

~ : .mem ( -- )
     (conf? cr
    ." data stack  : " s0 @ pad - 256 -
                       .bytes
    ." return stack: " r0 @ s0 @ -
                       .bytes
    ." staticbuffer: " ]static static[
                       - .bytes
    ." codebuffer  : " codesize  .bytes
    ." symbol table: " symtabsize .bytes
    ." hash table  : " #globals .
                       ." elements" cr
    ." heap        : " #links .
                       ." links" cr
    ." memory limit: " himem   u. cr
   IF
    ." bad memory setup: staticbuffer !"
   cr THEN ;




\ *** Block No. 17, Hexblock 11

\   memman:                    24aug94pz

| : relocate-tasks  ( newUP -- )
 up@ dup BEGIN  1+ under @ 2dup -
 WHILE  rot drop  REPEAT  2drop ! ;

~ : relocate  ( stacklen rstacklen -- )
 empty  256 max 8192 min  swap
 256 max 8192 min  pad + 256 +
 2dup + 2+ limit u>
 abort" stacks beyond limit"
 under  +   origin $A + !        \ r0
 dup relocate-tasks
 up@ 1+ @   origin   1+ !        \ task
       6 -  origin  8 + ! cold ; \ s0











\ *** Block No. 18, Hexblock 12

\ listman: loadscreen          20sep94pz

\ terminologie:
\ hook-into     hook-out
\ heap>         >heap
\ init-heap

  .( module listman ) cr

  1 2 +thru
















\ *** Block No. 19, Hexblock 13

\ listman:                     12mar91pz

~ : hook-into ( element list -- )
     2dup  @ swap !  !  ;

~ : hook-out  ( list -- element/0 )
     dup @ dup
        IF dup @ rot !
        ELSE nip THEN ;


| variable heap

~ : heap> ( -- element/0 )
     heap @ dup
        IF dup @ heap !
        ELSE *heapovfl* error THEN ;

~ : >heap ( element -- )
      heap hook-into ;






\ *** Block No. 20, Hexblock 14

\   listman: init              12mar91pz

~ : init-heap
     heap off
     ]heap heap[ ?DO
       I >heap
     /link +LOOP ;

  init: init-heap

















\ *** Block No. 21, Hexblock 15

                               02mar94pz

























\ *** Block No. 22, Hexblock 16

                               02mar94pz

























\ *** Block No. 23, Hexblock 17

                               02mar94pz

























\ *** Block No. 24, Hexblock 18

\ fehlermeldungen              20sep94pz

  .( module errormessages ) cr

  1 3 +thru





















\ *** Block No. 25, Hexblock 19

\ errormessages                11sep94pz

~ stringtab errormessage

~ x *syntax*      x" syntax error"
\ x *in-file*     x" source file error"
~ x *eof*         x" end of file"
~ x *symovfl*
     x" symbol table overflow"
~ x *doubledef*
     x" double defined symbol"
~ x *glbovfl*
     x" hash table overflow"
~ x *functolong*  x" function too long"
\ x *out-file*    x" output file error"
~ x *undef*       x" undefined symbol"
~ x *nofunc*      x" bad function call"
~ x *inc-nest*
     x" include nesting too deep"
~ x *noref*       x" reference needed"
~ x *novector*    x" vector needed"
~ x *noptr*       x" pointer needed"
~ x *noconst*
     x" constant expression needed"


\ *** Block No. 26, Hexblock 1a

\   errormessages              11sep94pz

~ x *noswitch*    x" no active switch"
~ x *ill-brk*
     x" nothing to break or continue"
~ x *ill-default* x" illegal default"
~ x *heapovfl*    x" heap overflow"
~ x *!=type*      x" incompatible type"
~ x *lex*         x" lexical error"
~ x *eol*
     x" unexpected end of line"
~ x *comment*
     x" unclosed comment from line "
~ x *ignored*     x" word ignored: "
\ x *file*        x" file error"
\ x *stackovfl*   x" stack overflow"
~ x *expected*    x" expected: "
~ x *initer*      x" bad initializer"
~ x *???*         x" makes no sense"
~ x *double-func* x" double function"
~ x *double-ptr*  x" double pointer"
~ x *param*       x" bad parameter"
~ x *longline*    x" overlong line"
~ x *preprocessor* x" preprocessor"


\ *** Block No. 27, Hexblock 1b

\   errormessages              07may95pz

~ x *preprocess-in-string*
     x" preprocessor call in string"
~ x *memsetup*
    x" bad memory setup: no code space"
~ x *nolayout*  x" no '#pragma cc64'"
~ x *bad-main*  x" main's no function"
~ x *link*      x" linker file error"
~ x *obj-long* x" object file too long"
~ x *obj-short*
    x" object file too short"
~ x *stack*     x" stack overflow"
~ x *rstack*  x" return stack overflow"
~ x (*compiler*   x" compiler error"
  endtab

~ create err-blk  0 ,

| : *compiler* ( -- )
     blk @  err-blk @ +  >in @ 41 /
     1024 * + [compile] literal
     compile err-blk  compile !
     compile (*compiler* ; immediate


\ *** Block No. 28, Hexblock 1c

                               02mar94pz

























\ *** Block No. 29, Hexblock 1d

                               02mar94pz

























\ *** Block No. 30, Hexblock 1e

\ input: loadscreen            20sep94pz

\ terminologie:

\ newline
\ open-input    close-input
\ open-include  close-include
\ char>         +char
\ line
\ comment-line  comment-state
\ #eof
\ printcontext

  .( module input ) cr

  1 5 +thru










\ *** Block No. 31, Hexblock 1f

\   input :  variable          14sep94pz

| 4 constant max-level
| variable include-level
| create name[]
          /filename max-level * allot
| create line[]    max-level 2* allot
| create filepos[] max-level 2* allot

~ variable comment-state
~ variable comment-line
| variable eof

~ doer preprocess

| variable inptr

~ : +char  ( -- )  1 inptr +! ;
~ : char>  ( -- c )  inptr @ c@ ;
\ : char>  ( -- c )   eof @
\    IF #eof ELSE inptr @ c@ THEN ;

| : res-inptr  linebuf inptr ! ;



\ *** Block No. 32, Hexblock 20

\   input: open/close-input    11sep94pz

~ : source-name     include-level @
                 /filename * name[] + ;
~ : line  include-level @ 2* line[] + ;
| : filepos         include-level @
                       2* filepos[] + ;

~ : close-input ( -- )
     comment-state @
        IF *comment* error
        comment-line @ u.
        " */" linebuf strcpy
        ELSE linebuf off THEN
     source-file fclose ;

| : open-source  ( -- )
     ascii r ascii s source-name
     source-file fopen  res-inptr ;

~ : open-input ( name -- )
     source-name strcpy
     eof off  comment-state off
     line off  linebuf off  filepos off
     open-source ;

\ *** Block No. 33, Hexblock 21

\   input: open/close-include  11sep94pz

~ : close-include ( -- )
     close-input
     include-level @
        IF -1 include-level +!
        ." end of include file" cr
        reopen-outfiles  open-source
        source-file fsetin
        filepos @ fskip  funset
        ELSE ." end of source file" cr
        #eof eof ! THEN ;

~ : open-include  ( name -- )
     ." include-file: "
     dup count type cr
     include-level @ 1+ dup max-level u<
        IF include-level !
        source-file fclose
        reopen-outfiles  open-input
        ELSE *inc-nest* error  2drop
        THEN ;




\ *** Block No. 34, Hexblock 22

\   input :  newline           14sep94pz

~ variable listing  listing on

| : printsourceline  ( -- )
     linebuf /linebuf bounds
     DO I c@ ?dup 0= IF LEAVE THEN
     emit LOOP cr ;

~ : newline ( -- )
     source-file feof?
        IF close-include
        eof @ ?exit THEN
     1 line +!
     source-file fsetin
     linebuf /linebuf 1- #cr fget2delim
        *longline* ?error
     dup filepos +!
     1- /linebuf 1- umin
     linebuf + 0 swap c!
     funset
     listing @ IF line @ u.
            ." : " printsourceline THEN
     res-inptr  preprocess ;


\ *** Block No. 35, Hexblock 23

\   input :  printcontext      11sep94pz

make printcontext  ( -- )
      context? @ 0= ?exit
      linebuf c@ 0= ?exit
      printsourceline
      inptr @ linebuf - 1- 0 max
      spaces ASCII ^ emit  cr ;

~ : init-input ( -- )
     include-level off
     linebuf off  res-inptr
     context? on ;
    init: init-input

\ context? is defined in errorhandler
\ and shall avoid context printing
\ if an error occurs during init while
\ no valid linebuf content exists.







\ *** Block No. 36, Hexblock 24

\ scanner: loadscreen          20sep94pz

\ terminologie:
\   nextword   backword
\   mark       advanced?
\   word.
\   start$     build$      end$
\   alle tokens
\   init-scanner

  .( module scanner ) cr

 1 15 +thru













\ *** Block No. 37, Hexblock 25

\   scanner:                   26feb91pz

| : alpha?  ( c -- flag )
    dup  ascii a ascii [ uwithin
    over ascii A ascii { uwithin or
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



\ *** Block No. 52, Hexblock 34

                               13feb91pz

























\ *** Block No. 53, Hexblock 35

\ old storestring              23feb91pz

























\ *** Block No. 54, Hexblock 36

\ errorhandler : loadscreen    20sep94pz

  .( module errorhandler ) cr

  1 2 +thru





















\ *** Block No. 55, Hexblock 37

\   errorhandler               11sep94pz

~ variable any-errors?
~ variable context?
~ doer printcontext

~ : init-error  any-errors? off
                context? off ;
    init: init-error

~ doer close-files  ( -- )
~ doer scratchfiles ( -- )














\ *** Block No. 56, Hexblock 38

\   errorhandler               11sep94pz

~ : error ( errnum -- )
     errormessage swap string[]
     cr >string count type  cr
     printcontext  any-errors? on ;

~ : ?error ( flag errnum -- )
    swap IF error ELSE drop THEN ;


~ : fatal ( errnum -- )
     dup error  (*compiler* =
       IF err-blk @ dup 1024 /
       swap 1023 and ." location: blk "
       . ."  line " . cr THEN
     close-files scratchfiles
     true abort" fatal error" ;

~ : ?fatal ( flag errnum -- )
     swap IF fatal ELSE drop THEN ;





\ *** Block No. 57, Hexblock 39

                               02mar94pz

























\ *** Block No. 58, Hexblock 3a

                               02mar94pz

























\ *** Block No. 59, Hexblock 3b

                               02mar94pz

























\ *** Block No. 60, Hexblock 3c

\ symtab: loadscreen           20sep94pz

\ terminologie:
\ findlocal    putlocal
\ nestlocal    unnestlocal
\ findglobal   putglobal
\ init-symtab

  .( module symtab ) cr

  1 5 +thru

\\ symbol format:
 [ name$(counted)][ /symbol bytes data ]

symbol table format:
 symtab[//globals//   //locals//]symtab
          globals>^   ^locals>

 hash[////pointers to globals/////]hash

marks in the local symbol table:
 end of block local table:  )block
 end of total local table:  )local


\ *** Block No. 61, Hexblock 3d

\ symtab: div.                 11mar91pz

| 63 constant /name
| 255 constant )local   \ marken
| 254 constant )block   \
\ es muss /name < )block < )local < 256

| : cutname ( name -- )
     dup c@ /name umin swap c! ;

| create dummy  /symbol allot

| variable globals>
| variable locals>

~ : init-symtab
     hash[ ]hash over - erase
     symtab[ globals> !
     ]symtab 1-  )local over c!
     locals> ! ;

    init: init-symtab




\ *** Block No. 62, Hexblock 3e

\ symtab: locals               14feb91pz

| : (findloc) ( name endmark -- dfa/0 )
     ]symtab locals> @
     ?DO dup I c@ > not
        IF 2drop 0 UNLOOP exit THEN
     I c@ /name > IF 1
        ELSE over I strcmp
           IF 2drop I count +
           UNLOOP exit THEN
        I c@ 1+ /symbol + THEN
     +LOOP  *compiler* fatal ;

~ : findlocal ( name -- dfa/0 )
     dup cutname  )local (findloc) ;

~ : findparam ( name -- dfa/0 )
     dup cutname  )block (findloc) ;

| : spacious? ( n -- flag )
     locals> @ globals> @ - u> 0= ;





\ *** Block No. 63, Hexblock 3f

\   symtab: locals             14feb91pz

~ : putlocal ( name -- dfa )
     dup c@ 0= IF drop dummy exit THEN
     dup cutname   dup )block (findloc)
        IF drop dummy
        *doubledef* error  exit THEN
     dup c@ 1+ /symbol + spacious?
        IF locals> @ /symbol - under
        over c@ 1+ under - under
        locals> !  cmove
        ELSE drop dummy
        *symovfl* error THEN ;

~ : nestlocal ( -- )
     1 spacious? IF locals> @ 1-
     )block over c!  locals> !
     ELSE *symovfl* error THEN ;

~ : unnestlocal ( -- )
     ]symtab locals> @ ?DO
     I c@ )block = IF I 1+ locals> !
                   UNLOOP exit THEN
     LOOP *compiler* fatal ;


\ *** Block No. 64, Hexblock 40

\ symtab: globals              18feb91pz

| : hash ( name -- n )
     0 swap count bounds
        ?DO 2* I c@ + LOOP ;

| : (findglb) ( name -- dfa   true )
              ( name -- adr/0 false )
     dup hash #globals u/mod drop
     2* hash[ + dup
     DO I ]hash u< not
        IF hash[ >I THEN
     I @ ?dup
        IF over strcmp
           IF drop I @ count +  true
           UNLOOP exit THEN
        ELSE drop I  false UNLOOP exit
        THEN
     2 +LOOP drop 0  false ;







\ *** Block No. 65, Hexblock 41

\   symtab: globals            14feb91pz

~ : findglobal ( name -- dfa/0 )
     dup cutname  (findglb) and ;

~ : putglobal  ( name -- dfa )
     dup c@ 0= IF drop dummy exit THEN
     dup cutname  dup (findglb)
        IF 2drop dummy
        *doubledef* error exit THEN
     ?dup 0=
        IF drop dummy
        *glbovfl* error exit THEN
     over c@ 1+ /symbol +  spacious?
        IF globals> @ swap !
        globals> @ over c@ 1+ cmove
        globals> @ count +
        dup  /symbol + globals> !
        ELSE 2drop dummy
        *symovfl* error THEN ;






\ *** Block No. 66, Hexblock 42

\ savestack: loadscreen        26feb91pz

\ terminologie:

\ +savestack    -savestack
\ ?savestack    ?loadstack

  1 3 +thru


















\ *** Block No. 67, Hexblock 43

\   savestack:                 10sep94pz

| create st-name ," %%st  "

| : th-file  ( n -- )
     dup 255 u> *stackovfl* ?fatal
     16 /mod 256 * +
     [ ascii a dup 256 * + ] literal
     +  st-name 5 + ! ;

| : st-open ( mode -- )
     ascii s stack-file st-name fopen ;

| : st-close ( -- )
     stack-file fclose ;
\\
| : scratch-stacks ( -- )
     stack-dev 2@ drop 15 busout
     " s0:%%st??" count bustype
     busoff ;
\    derror? *file* ?fatal ;





\ *** Block No. 68, Hexblock 44

\   savestack:                 10sep94pz

| : savestack ( oldstack n -- )
     th-file  ascii w st-open
     stack-file fsetout
     sp@ s0 @ over -
     dup >lo/hi fputc fputc
     fputs   funset
     st-close  clearstack ;

| : loadstack ( n -- oldstack )
     th-file  ascii r st-open
     stack-file fsetin
     fgetc fgetc swap lo/hi> >r
     s0 @ r@ -  dup here $100 + s0 @ 1+
     uwithin not *compiler* ?fatal
     sp!  sp@ r> fgets drop funset
     st-close ;








\ *** Block No. 69, Hexblock 45

\   savestack:                 09sep94pz

| variable stacks

~ : ?savestack ( -- )
     sp@ here - $110 u<
        IF stacks @ savestack
        1 stacks +! THEN ;

~ : ?loadstack ( -- )
     depth 0=
        IF stacks @ dup
        0= *compiler* ?fatal
        1- dup stacks !  loadstack
        THEN ;

~ : +savestack ( -- )  stacks off ;

~ : -savestack ( -- )
     stacks @  *compiler* ?fatal ;
\    scratch-stacks ;





\ *** Block No. 70, Hexblock 46

                               02mar94pz

























\ *** Block No. 71, Hexblock 47

                               02mar94pz

























\ *** Block No. 72, Hexblock 48

\ codehandler: loadscreen      20sep94pz

  .( module codehandler ) cr

  1 4 +thru

\ terminologie:

\ fuer programmcode:
\ b!  w!  b,  w,  pc  *=  flushcode

\ fuer statische variable:
\ cstat,  stat,  >staticadr  staticadr>
\ flushstatic

\ fuer dynamische variable:
\ tos-offs  dyn-allot

\ fuer codelayout:
\ lib.first          codelayout.ok
\ code.first         end-of-code
\ code.last
\ statics.first
\ statics.libfirst
\ statics.last

\ *** Block No. 73, Hexblock 49

\   codehandler: dynamics,init 19apr94pz

~ variable tos-offs

~ : dyn-allot ( n -- offs )
     tos-offs @  swap tos-offs +! ;



~ doer flushcode ( -- )

~ doer flushstatic ( -- )


| variable nolayout

~ : init-codehandler  nolayout on ;

   init: init-codehandler







\ *** Block No. 74, Hexblock 4a

\   codehandler: code          19apr94pz

| variable >pc
~ : pc  >pc @ ;

| variable codeoffset
| : clearcode ( -- )
     pc code[ - codeoffset ! ;
~ : *=   >pc !  clearcode ;

| : >codeadr ( pc-adr -- code-buf-adr )
    nolayout @  *nolayout* ?fatal
    codeoffset @ - dup
    code[ ]code 1- uwithin
    0= *functolong* ?fatal ;

~ : b! ( 8b pc-adr -- )  >codeadr c! ;
~ : w! ( 16b pc-adr -- )  >codeadr ! ;

~ : b,  ( 8b -- )     pc b! 1 >pc +! ;
~ : w,  ( 16b -- )    pc w! 2 >pc +! ;





\ *** Block No. 75, Hexblock 4b

\   codehandler: statics       19apr94pz

| variable static-offset
| variable static>

| : clearstatic ( -- )
   static[ static> ! ;

~ : staticadr> ( -- current.adress )
     nolayout @  *nolayout* ?fatal
     static-offset @ static> @ - ;

~ : >staticadr ( adr -- )
     clearstatic
     static> @ + static-offset ! ;

~ : cstat, ( 8b -- )
     static> @ c!  1 static> +!
     static> @ ]static u< not
        IF flushstatic THEN ;

~ : stat, ( 16b -- )
     >lo/hi cstat, cstat, ;



\ *** Block No. 76, Hexblock 4c

\   codehandler : codelayout   11sep94pz

~ variable lib.first
~ variable code.first
~ variable code.last
~ variable statics.first
~ variable statics.libfirst
~ variable statics.last
~ variable lib.codename  15 allot
~ variable lib.initname  15 allot

~ create code.suffix ," .o"
~ create init.suffix ," .i"
~ create decl.suffix ," .h"
~ : cut-suffix  ( str -- )
     dup c@ 2- swap c! ;

~ : codelayout.ok  nolayout off ;

~ : end-of-code  ( -- )
     flushstatic
     flushcode
     staticadr> statics.first !
     pc         code.last     ! ;


\ *** Block No. 77, Hexblock 4d

\ codeoutput: flushcode/static 11sep94pz

make flushcode ( -- )
   code-file fsetout
   code[  pc >codeadr  over -  fputs
   funset  clearcode ;

make flushstatic ( -- )
   static-file fsetout
   static[  static> @  over - fputs
   static[ static> @ - static-offset +!
   funset  clearstatic ;

\\ noch schlecht modularisiert:
   greift auf interne worte des
   codehandlers zurueck.










\ *** Block No. 78, Hexblock 4e

\ fileman: loadscreen          20sep94pz

  .( module fileman ) cr

  1 3 +thru

\ terminologie:

\ source-file
\ code-file       code-name
\ static-file     static-name

\ /filename
\ dev             dev#

\ close-files     scratchfiles
\ open-outfiles   close-outfiles
\ reopen-outfiles

\ init-files






\ *** Block No. 79, Hexblock 4f

\   fileman:                   20sep94pz

~ fhandle source-file
~ fhandle code-file
~ fhandle static-file
~ fhandle exe-file

~ 17 constant /filename
~ create exe-name   /filename allot

~ create code-name    ," %%code"
~ create static-name  ," %%init"

  create dev#  8 c,
  : dev   ( -- dev )  dev# c@ ;
~ create aux#  8 c,
~ : aux   ( -- aux )  aux# c@ ;

~ : init-files
     dev 2 source-file  set-fhandle
     aux 3 code-file    set-fhandle
     aux 4 static-file  set-fhandle
     dev 5 exe-file     set-fhandle ;

    init: init-files

\ *** Block No. 80, Hexblock 50

\   fileman:                   11sep94pz

| : loadadr!  ( handle -- )
     fsetout 0 fputc 64 fputc funset ;

~ : open-outfiles  ( -- )
     ascii w ascii p code-name
     code-file fopen
     code-file loadadr!
     ascii w ascii p static-name
     static-file fopen
     static-file loadadr! ;

~ : close-outfiles  ( -- )
     code-file   fclose
     static-file fclose ;

~ : reopen-outfiles  ( -- )
     close-outfiles
     ascii a ascii p code-name
     code-file fopen
     ascii a ascii p static-name
     static-file fopen ;



\ *** Block No. 81, Hexblock 51

\   fileman:                   13sep94pz

make close-files  ( -- )
      source-file  fclose
      exe-file     fclose
      close-outfiles ;

make scratchfiles ( -- )
     ." scratching temporary files" cr
     dev 15 busout
     " s0:%%*" count bustype busoff ;















\ *** Block No. 82, Hexblock 52

                               02mar94pz

























\ *** Block No. 83, Hexblock 53

                               02mar94pz

























\ *** Block No. 84, Hexblock 54

\ assembler loadscreen         20sep94pz

  .( module assembler ) cr

  1 17 +thru








\\ $zp wird implizit benutzt von
- .not
- .mult .mult#
- .div  .div#  .#div
- .mod  .mod#  .#mod
- .add .sub .and .or  .xor
- .eq  .ne  .ge  .lt  .gt  .le
- .jmn  .jmn-ahead
- .jmz  .jmz-ahead




\ *** Block No. 85, Hexblock 55

\   assembler: runtime         21aug94pz

| variable size   2 size !
~ variable >base
~ variable >zp
~ variable >runtime

| variable o    $08c7 o !
\ hibyte: offset-^ ^-lobyte: kennbyte
| : rt ( -- )  o @ constant
         $0300 o +! ;
\ offs +=3-^ ^-kennbyte nicht aendern

| rt $jmp(zp)
| rt $switch
| rt $mult
| rt $divmod
| rt $shl
| rt $shr







\ *** Block No. 86, Hexblock 56

\   assembler: parameter       25may91pz

| $ff07 constant &
| $ff17 constant &+1
|   $27 constant <&
|   $37 constant >&
|   $47 constant $zp
|   $57 constant $zp+1
|   $67 constant $base
|   $77 constant $base+1
| : w:  $87 c, 21 ;
| : ;w  21 ?pairs $97 c, ;
| : b:  $a7 c, 22 ;
| : ;b  22 ?pairs $b7 c, ;

| : (wb:   ( par I endcode -- step )
           >r nip dup BEGIN 1+ dup c@
           r@ = UNTIL swap - 1+ rdrop ;
          ( par I -- step )
| : (;wb  2drop 1 ;
| : (w:   size @ 2- IF $97 (wb:
                    ELSE (;wb THEN ;
| : (b:   size @ 1- IF $b7 (wb:
                    ELSE (;wb THEN ;


\ *** Block No. 87, Hexblock 57

\   assembler: parameter ausw. 25may91pz

           ( par I -- step )
| : 0+w,   drop     w,          2 ;
| : 1+w,   drop  1+ w,          2 ;
| : <b,    drop >lo b,          1 ;
| : >b,    drop >hi b,          1 ;
| : zp,    2drop >zp @    b,    1 ;
| : zp+1,  2drop >zp @ 1+ b,    1 ;
| : ba,    2drop >base @    b,  1 ;
| : ba+1,  2drop >base @ 1+ b,  1 ;
| : rt,    1+ c@ >runtime @ + w,
                          drop  2 ;

| : compiler-error  *compiler* fatal ;

| create atab
 ' 0+w, ,  ' 1+w, ,  ' <b, ,  ' >b, ,
 ' zp, ,  ' zp+1, ,  ' ba, ,  ' ba+1, ,
 ' (w: ,  ' (;wb ,   ' (b: ,  ' (;wb ,
 ' rt, ,
 ' compiler-error dup dup , , ,




\ *** Block No. 88, Hexblock 58

\   assembler: a: a&: ;a       26may91pz

| : (a: ( -- sys )
     create  here 0 c, 20 assembler ;

| : ;a ( sys -- )
     20 ?pairs  current @ context !
     here over - 1- swap c! ;

| : a, ( par I b -- step )
     dup $f and $7 =
        IF 2/ 2/ 2/ 2/ 2*
        atab + @ execute
        ELSE b, 2drop 1 THEN ;

| : a&: (a: does> ( par pfa -- )
     count bounds
     DO dup I dup c@ a, +LOOP drop ;

| : a: (a: does> ( pfa -- )
     count bounds
     DO 0 I dup c@ a, +LOOP ;




\ *** Block No. 89, Hexblock 59

\   assembler: basics          26may91pz

~ a&: .lda#   <& # lda  >& # ldx  ;a

~ a: .pha     pha tay txa pha tya  ;a
~ a: .pha'    pha     txa pha      ;a
~ a: .pla     pla     tax pla      ;a

~ ' w, ALIAS .word
~ ' b, ALIAS .byte

~ a&: .jsr    & jsr  ;a
~ a:  .jsr(zp)  $jmp(zp) jsr ;a
~ a:  .rts    rts ;a

| a&: .ldy#   <& # ldy ;a
      ' .ldy#
~ ALIAS .args

~ a: .shla  .a asl tay txa
            .a rol tax tya ;a
~ a: .shra  tay txa .a lsr
            tax tya .a ror ;a
~ a: .and#255  0 # ldx ;a


\ *** Block No. 90, Hexblock 5a

\   assembler: basics          24may91pz

~ a: .pop-zp  tay pla $zp+1 sta
                  pla $zp   sta  tya ;a
~ a: .sta-zp  $zp sta  $zp+1 stx ;a
~ a: .lda-zp  $zp lda  $zp+1 ldx ;a

~ a: .lda-base $base lda $base+1 ldx ;a

~ a&: .link#  tay clc   $base lda
              <& # adc  $base sta
              $base+1 lda  >& # adc
              $base+1 sta  tya ;a

~ a: .switch  $switch jsr ;a











\ *** Block No. 91, Hexblock 5b

\   assembler: arithmetics     27may91pz

~ a: .not  $zp stx  0 # ldx  $zp ora
           0= ?[ dex ]? txa ;a

~ a: .neg  $ff # eor tay txa
           $ff # eor tax
           iny 0= ?[ inx ]? tya ;a

~ a: .inv  $ff # eor tay txa
           $ff # eor tax tya ;a















\ *** Block No. 92, Hexblock 5c

\   assembler: arithmetics     27may91pz

~ a&: .add#   clc  <& # adc  tay  txa
              >& # adc  tax  tya  ;a

~ a&: .sub#   sec  <& # sbc  tay  txa
              >& # sbc  tax  tya  ;a

~ a&: .#sub   sec  $ff # eor  <& # adc
              tay  txa  $ff # eor
              >& # adc  tax  tya  ;a

~ a&: .and#   <& # and  tay  txa
              >& # and  tax  tya  ;a

~ a&: .or#    <& # ora  tay  txa
              >& # ora  tax  tya  ;a

~ a&: .xor#   <& # eor  tay  txa
              >& # eor  tax  tya  ;a






\ *** Block No. 93, Hexblock 5d

\   assembler: arithmetics     24may91pz

| a: .add-zp  clc  $zp adc  tay  txa
                 $zp+1 adc  tax  tya ;a

| a: .sub-zp  sec  $zp sbc  tay  txa
                 $zp+1 sbc  tax  tya ;a

| a: .and-zp    $zp and  tay  txa
              $zp+1 and  tax  tya  ;a

| a: .or-zp     $zp ora  tay  txa
              $zp+1 ora  tax  tya  ;a

| a: .xor-zp    $zp eor  tay  txa
              $zp+1 eor  tax  tya  ;a

~  : .add  .sta-zp  .pla  .add-zp ;
~  : .sub  .sta-zp  .pla  .sub-zp ;
~  : .and  .sta-zp  .pla  .and-zp ;
~  : .or   .sta-zp  .pla  .or-zp  ;
~  : .xor  .sta-zp  .pla  .xor-zp ;




\ *** Block No. 94, Hexblock 5e

\   assembler: arithmetics     24may91pz

| a&: .ldzp#  tay  <& # lda    $zp sta
                   >& # lda  $zp+1 sta
              tya  ;a
| a: (.mult    $mult   jsr ;a
| a: (.divmod  $divmod jsr ;a

~ : .mult#  .sta-zp  .lda#  (.mult ;
~ : .mult   .sta-zp  .pla   (.mult ;

~ : .div#   .ldzp#  (.divmod ;
~ : .#div   .sta-zp  .lda#  (.divmod ;
~ : .div    .sta-zp  .pla   (.divmod ;

~ : .mod#   .div#  .lda-zp ;
~ : .#mod   .#div  .lda-zp ;
~ : .mod    .div   .lda-zp ;








\ *** Block No. 95, Hexblock 5f

\   assembler: arithmetics     27may91pz

| a: .tay   tay ;a
| a: (.shl  $shl jsr ;a
| a: (.shr  $shr jsr ;a

~ : .shl   .tay   .pla   (.shl ;
~ : .shl#  .ldy#         (.shl ;
~ : .#shl  .tay   .lda#  (.shl ;

~ : .shr   .tay   .pla   (.shr ;
~ : .shr#  .ldy#         (.shr ;
~ : .#shr  .tay   .lda#  (.shr ;

\\ 'unsized' in/decrements
~ a&: .incr  & inc  0= ?[ &+1 inc ]? ;a
~ a&: .decr  & ldy  0= ?[ &+1 dec ]?
             & dec ;a

~ a&: .2incr  & ldy  $fe # cpy
              cs ?[ &+1 inc ]?
              & inc  & inc    ;a
~ a&: .2decr  & ldy    2 # cpy
              cc ?[ &+1 dec ]?
              & dec  & dec    ;a

\ *** Block No. 96, Hexblock 60

\   assembler: arithmetics     24may91pz

| a&: .cmp#  0 # ldy   >& # cpx
             sec 0< ?[ clc ]?
             0= ?[ <& # cmp ]? ;a

| a: .cmp-zp 0 # ldy   $zp+1 cpx
             sec 0< ?[ clc ]?
             0= ?[ $zp   cmp ]? ;a
|  : .cmp .sta-zp .pla .cmp-zp ;


| a: (.eq   0=  ?[ dey ]? tya tax  ;a
| a: (.ne   0<> ?[ dey ]? tya tax  ;a
| a: (.ge   cs  ?[ dey ]? tya tax  ;a
| a: (.lt   cc  ?[ dey ]? tya tax  ;a
| a: (.gt   cs  ?[ 0<> ?[ dey ]? ]?
                          tya tax  ;a
| a: (.le   here 4 + bcc  0= ?[ dey ]?
                          tya tax  ;a






\ *** Block No. 97, Hexblock 61

\   assembler: arithmetics     24may91pz

~ : .eq   .cmp    (.eq ;
~ : .ne   .cmp    (.ne ;
~ : .eq#  .cmp#   (.eq ;
~ : .ne#  .cmp#   (.ne ;

~ : .ge   .cmp    (.ge ;
~ : .lt   .cmp    (.lt ;
~ : .ge#  .cmp#   (.ge ;
~ : .lt#  .cmp#   (.lt ;

~ : .gt   .cmp    (.gt ;
~ : .le   .cmp    (.le ;
~ : .gt#  .cmp#   (.gt ;
~ : .le#  .cmp#   (.le ;










\ *** Block No. 98, Hexblock 62

\   assembler: 'sized'         18apr94pz

~ : .size  size ! ;
\ evtl noch bei size <>1,2 : error

~ a&: .lda#.s
   <& # lda  w: >& # ldx ;w ;a


~ a&: .lda.s
   & lda w: &+1 ldx ;w b: 0 # ldx ;b ;a

~ a&: .sta.s  & sta  w: &+1 stx ;w ;a


~ a: .lda.s(zp)
   w: 1 # ldy  $zp )y lda  tax  dey ;w
   b: 0 # ldx 0 # ldy ;b  $zp )y lda ;a

~ a: .sta.s(zp)
   0 # ldy  $zp )y sta  w: pha txa
       iny  $zp )y sta     pla ;w ;a




\ *** Block No. 99, Hexblock 63

\   assembler: 'sized'         18apr94pz

| a&: .lda(base),&
   <& # ldy  $base )y lda  w: tax dey
             $base )y lda ;w
    b: 0 # ldx ;b ;a

~ : .lda.s(base),#
      dup 254 u>
        IF .lda-base  .add#
           .sta-zp    .lda.s(zp)
        ELSE size @ 1- IF 1+ THEN
           .lda(base),& THEN ;


| a&: .sta(base),&
   <& # ldy  $base )y sta  w: pha txa
        iny  $base )y sta     pla ;w ;a

~ : .sta.s(base),#
      dup 254 u>
        IF .pha'  .lda-base  .add#
           .sta-zp  .pla  .sta.s(zp)
        ELSE .sta(base),& THEN ;


\ *** Block No. 100, Hexblock 64

\   assembler: 'sized'         27may91pz

~ a&: .incr.s
       & inc w: 0= ?[ &+1 inc ]? ;w ;a

~ a&: .decr.s
       w: & ldy  0= ?[ &+1 dec ]? ;w
       & dec ;a

~ a&: .2incr.s
       w: & ldy  $fe # cpy
       cs ?[ &+1 inc ]? ;w
       & inc  & inc ;a

~ a&: .2decr.s
       w: & ldy    2 # cpy
       cc ?[ &+1 dec ]? ;w
       & dec  & dec ;a








\ *** Block No. 101, Hexblock 65

\   assembler: jumps           24may91pz

~ a&: .jmp  & jmp ;a
       ' pc
~ ALIAS .label

~ : .jmp-ahead    pc  0 .jmp ;
~ : .resolve-jmp  pc swap 1+ w! ;

| a: .skip0<>   $zp stx  $zp ora
                here 5 + bne ;a
| a: .skip0=    $zp stx  $zp ora
                here 5 + beq ;a

~ : .jmz        .skip0<>  .jmp ;
~ : .jmn        .skip0=   .jmp ;

~ : .jmz-ahead  .skip0<>  .jmp-ahead ;
~ : .jmn-ahead  .skip0=   .jmp-ahead ;







\ *** Block No. 102, Hexblock 66

\   assembler: old comps       24may91pz

| a&: .cmp#        >& # cpx
             0< ?[ clc ]?
             0= ?[ <& # cmp ]? ;a
| a: .cmp-zp       $zp+1 cpx
             0< ?[ clc ]?
             0= ?[ $zp   cmp ]? ;a
|  : .cmp .sta-zp .pla .cmp-zp ;

| a: .beq   here 5 + beq ;a
| a: .bge   here 5 + bcs ;a
| a: .bgt   here 4 + beq
            here 5 + bcs ;a
| a: .0/-1    0 # lda  $2c c,
            $ff # lda  tax ;a
| a: .-1/0  $ff # lda  $2c c,
              0 # lda  tax ;a
| : (.eq  .beq  .0/-1 ;
| : (.ne  .beq  .-1/0 ;
| : (.ge  .bge  .0/-1 ;
| : (.lt  .bge  .-1/0 ;
| : (.gt  .bgt  .0/-1 ;
| : (.le  .bgt  .-1/0 ;


\ *** Block No. 103, Hexblock 67

                               02mar94pz

























\ *** Block No. 104, Hexblock 68

\ preprocessor loadscreen      20sep94pz

\ terminologie:

\  preprocess

  .( module preprocessor ) cr

 1 6 +thru

\\ The preprocessor is a really bad
 hack which depends deeply on special
 properties of input, scanner and
 codegen.












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


\ *** Block No. 111, Hexblock 6f

                               02mar94pz

























\ *** Block No. 112, Hexblock 70

\ file-i/o                     20sep94pz

  .( module file-i/o ) cr

  1 4 +thru





















\ *** Block No. 113, Hexblock 71

\   file-i/o                   21sep94pz

~ : fhandle  create 6 allot ;

~ : set-fhandle  ( dev 2nd handle -- )
     dup off  2+ 2! ;

| variable >handle
| : handle  >handle @ ;
~ -1 constant #eof

~ : feof?  ( handle -- flag ) @ ;


\\

~ variable fdelay  10 fdelay !

| : fwait  ( -- )
     fdelay @ 0 ?DO
     $00a1 @ BEGIN dup $00a1 @ - UNTIL
     drop LOOP ;




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













\ *** Block No. 117, Hexblock 75

\   file-i/o                   21sep94pz

~ : fcmd  ( handle string -- )
     2+ 2+ @ 15 busout
     count bustype busoff ;

~ : ferror?  ( handle -- ) drop ;

~ : freset  ( handle -- )
     " uj" swap fcmd ;
















\ *** Block No. 118, Hexblock 76



























\ *** Block No. 119, Hexblock 77



























\ *** Block No. 120, Hexblock 78

\ transient Assembler         c09may94pz

\needs code  1 +load























\ *** Block No. 121, Hexblock 79

\ Forth-6502 Assembler         20sep94pz
\ Basis: Forth Dimensions VOL III No. 5)

 .( transient forth assembler) cr


here   $800 hallot  heap dp !

Onlyforth  Assembler also definitions
         1 7 +thru

\ : .blk  ( -) blk @ ?dup
\    IF  ."  Blk " u. ?cr  THEN ;
\ ' .blk Is .status

: rr ." error in scr " scr @ .
     ."  at position " r# @ . cr ;

dp !

Onlyforth





\ *** Block No. 122, Hexblock 7a

\ Forth-83 6502-Assembler      20oct87re

: end-code   context 2- @  context ! ;

Create index
$0909 , $1505 , $0115 , $8011 ,
$8009 , $1D0D , $8019 , $8080 ,
$0080 , $1404 , $8014 , $8080 ,
$8080 , $1C0C , $801C , $2C80 ,

| Variable mode

: Mode:  ( n -)   Create c,
  Does>  ( -)     c@ mode ! ;

0   Mode: .A        1    Mode: #
2 | Mode: mem       3    Mode: ,X
4   Mode: ,Y        5    Mode: X)
6   Mode: )Y       $F    Mode: )







\ *** Block No. 123, Hexblock 7b

\ upmode  cpu                  20oct87re

| : upmode ( addr0 f0 - addr1 f1)
 IF mode @  8 or mode !   THEN
 1 mode @  $F and ?dup IF
 0 DO  dup +  LOOP THEN
 over 1+ @ and 0= ;

: cpu  ( 8b -)   Create  c,
  Does>  ( -)    c@ c, mem ;

 00 cpu brk $18 cpu clc $D8 cpu cld
$58 cpu cli $B8 cpu clv $CA cpu dex
$88 cpu dey $E8 cpu inx $C8 cpu iny
$EA cpu nop $48 cpu pha $08 cpu php
$68 cpu pla $28 cpu plp $40 cpu rti
$60 cpu rts $38 cpu sec $F8 cpu sed
$78 cpu sei $AA cpu tax $A8 cpu tay
$BA cpu tsx $8A cpu txa $9A cpu txs
$98 cpu tya






\ *** Block No. 124, Hexblock 7c

\ m/cpu                        20oct87re

: m/cpu  ( mode opcode -)  Create c, ,
 Does>
 dup 1+ @ $80 and IF $10 mode +! THEN
 over $FF00 and upmode upmode
 IF mem true Abort" invalid" THEN
 c@ mode @ index + c@ + c, mode @ 7 and
 IF mode @  $F and 7 <
  IF c, ELSE , THEN THEN mem ;

$1C6E $60 m/cpu adc $1C6E $20 m/cpu and
$1C6E $C0 m/cpu cmp $1C6E $40 m/cpu eor
$1C6E $A0 m/cpu lda $1C6E $00 m/cpu ora
$1C6E $E0 m/cpu sbc $1C6C $80 m/cpu sta
$0D0D $01 m/cpu asl $0C0C $C1 m/cpu dec
$0C0C $E1 m/cpu inc $0D0D $41 m/cpu lsr
$0D0D $21 m/cpu rol $0D0D $61 m/cpu ror
$0414 $81 m/cpu stx $0486 $E0 m/cpu cpx
$0486 $C0 m/cpu cpy $1496 $A2 m/cpu ldx
$0C8E $A0 m/cpu ldy $048C $80 m/cpu sty
$0480 $14 m/cpu jsr $8480 $40 m/cpu jmp
$0484 $20 m/cpu bit



\ *** Block No. 125, Hexblock 7d

\ Assembler conditionals       20oct87re

| : range?   ( branch -- branch )
 dup abs  $7F u> Abort" out of range " ;

: [[  ( BEGIN)  here ;

: ?]  ( UNTIL)  c, here 1+ - range? c, ;

: ?[  ( IF)     c,  here 0 c, ;

: ?[[ ( WHILE)  ?[ swap ;

: ]?  ( THEN)   here over c@  IF swap !
 ELSE over 1+ - range? swap c! THEN ;

: ][  ( ELSE)   here 1+   1 jmp
 swap here over 1+ - range?  swap c! ;

: ]]  ( AGAIN)  jmp ;

: ]]? ( REPEAT) jmp ]? ;




\ *** Block No. 126, Hexblock 7e

\ Assembler conditionals       20oct87re

$90 Constant CS     $B0 Constant CC
$D0 Constant 0=     $F0 Constant 0<>
$10 Constant 0<     $30 Constant 0>=
$50 Constant VS     $70 Constant VC

: not    $20 [ Forth ] xor ;

: beq    0<> ?] ;   : bmi   0>= ?] ;
: bne    0=  ?] ;   : bpl   0<  ?] ;
: bcc    CS  ?] ;   : bvc   VS  ?] ;
: bcs    CC  ?] ;   : bvs   VC  ?] ;













\ *** Block No. 127, Hexblock 7f

\ 2inc/2dec   winc/wdec        20oct87re

: 2inc  ( adr -- )
 dup lda  clc  2 # adc
 dup sta  CS ?[  swap 1+ inc  ]?  ;

: 2dec  ( adr -- )
 dup lda  sec  2 # sbc
 dup sta  CC ?[  swap 1+ dec  ]?  ;

: winc  ( adr -- )
 dup inc  0= ?[  swap 1+ inc  ]?  ;

: wdec  ( adr -- )
 dup lda  0= ?[  over 1+ dec  ]?  dec  ;

: ;c:
 recover jsr  end-code ]  0 last !  0 ;








\ *** Block No. 128, Hexblock 80

\ ;code Code code>          bp/re03feb85

Onlyforth

: Assembler
 Assembler   [ Assembler ] mem ;

: ;Code
 [compile] Does>  -3 allot
 [compile] ;      -2 allot   Assembler ;
immediate

: Code  Create here dup 2- ! Assembler ;

: >label  ( adr -)
 here | Create  immediate  swap ,
 4 hallot heap 1 and hallot ( 6502-alig)
 here 4 - heap  4  cmove
 heap last @ count $1F and + !  dp !
  Does>  ( - adr)   @
  state @ IF  [compile] Literal  THEN ;

: Label
 [ Assembler ]  here >label Assembler ;


\ *** Block No. 129, Hexblock 81

\ 2! 2@ 2variable 2constant clv12may94pz

~ Code 2!  ( d adr --)
 tya  setup jsr  3 # ldy
 [[  SP )Y lda  N )Y sta  dey  0< ?]
 1 # ldy  Poptwo jmp  end-code

~ Code 2@  ( adr -- d)
 SP X) lda  N sta  SP )Y lda  N 1+ sta
 SP 2dec  3 # ldy
 [[  N )Y lda  SP )Y sta  dey  0< ?]
 xyNext jmp  end-code

~ : 2Variable  ( --)   Create 4 allot ;
             ( -- adr)

~ : 2Constant  ( d --)   Create , ,
  Does> ( -- d)   2@ ;








\ *** Block No. 130, Hexblock 82

\ savesystem                   12may94pz

\needs savesystem (
\\ )
| : (savsys ( adr len -- )
 [ Assembler ] Next  [ Forth ]
 ['] pause  dup push  !  \ singletask
 i/o push  i/o off  bustype ;

~ : savesystem   \ name muss folgen
 save  8 2 busopen  0 parse bustype
 " ,p,w" count bustype  busoff
 8 2 busout  origin $17 -
 dup  $100 u/mod  swap bus! bus!
 here over - (savsys  busoff
 8 2 busclose
 0 (drv ! derror? abort" save-error" ;









\ *** Block No. 131, Hexblock 83

\ test *compiler* error        04sep94pz

  : test-err
     *compiler* fatal
;
  : test-err2
     *compiler* ?fatal ;



















\ *** Block No. 132, Hexblock 84



























\ *** Block No. 133, Hexblock 85



























\ *** Block No. 134, Hexblock 86



























\ *** Block No. 135, Hexblock 87



























\ *** Block No. 136, Hexblock 88



























\ *** Block No. 137, Hexblock 89



























\ *** Block No. 138, Hexblock 8a



























\ *** Block No. 139, Hexblock 8b



























\ *** Block No. 140, Hexblock 8c

\ testcodeoutput 2             26may91pz

make flushstatic ( -- )
   base push hex ." statics: "
   static> @ static[
   ?DO ?cr I c@ . LOOP ." ;end" cr
   static[ static> @ - static-offset +!
   clearstatic ;


| : tabelle  ( +n -- )
 Create     0 DO
 bl word number drop , LOOP
 Does> ( 8b1 -- 8b2 +n )
 + count swap c@ ;

-->









\ *** Block No. 141, Hexblock 8d

\ dis shortcode0               20oct87re

base @  hex

$80 | tabelle shortcode0
0B10 0000 0000 0341 2510 0320 0000 0332
0AC1 0000 0000 03A1 0E10 0000 0000 0362
1D32 0000 0741 2841 2710 2820 0732 2832
08C1 0000 0000 28A1 2D10 0000 0000 2862
2A10 0000 0000 2141 2410 2120 1C32 2132
0CC1 0000 0000 21A1 1010 0000 0000 2162
2B10 0000 0000 2941 2610 2920 1CD2 2932
0DC1 0000 0000 29A1 2F10 0000 0000 2962
0000 0000 3241 3141 1710 3610 3232 3132
04C1 0000 32A1 31B1 3810 3710 0000 0000
2051 1F51 2041 1F41 3410 3310 2032 1F32
05C1 0000 20A1 1FB1 1110 3510 2062 1F72
1451 0000 1441 1541 1B10 1610 1432 1532
09C1 0000 0000 15A1 0F10 0000 0000 1562
1351 0000 1341 1941 1A10 2210 1332 1932
06C1 0000 0000 19A1 2E10 0000 0000 1962

base !

-->

\ *** Block No. 142, Hexblock 8e

\ dis scode adrmode            20oct87re

| Create scode
 $23 c, $02 c, $18 c, $01 c,
 $30 c, $1e c, $12 c, $2c c,

| Create adrmode
 $81 c, $41 c, $51 c, $32 c,
 $91 c, $a1 c, $72 c, $62 c,

| : shortcode1 ( 8b1 - 8b2 +n)
 2/ dup 1 and
 IF  0= 0  exit  THEN
 2/ dup $7 and adrmode + c@
 swap 2/ 2/ 2/ $7 and scode + c@ ;

| Variable mode

| Variable length

-->





\ *** Block No. 143, Hexblock 8f

\ dis shortcode texttab        06mar86re

| : shortcode ( 8b1 -- +n )
 dup 1 and         ( ungerade codes)
 IF  dup $89 =
  IF  drop 2  THEN  shortcode1
 ELSE  shortcode0  ( gerade codes)
 THEN
 swap dup 3 and length !
 2/ 2/ 2/ 2/ mode ! ;

| : texttab   ( char +n 8b -- )
 Create
 dup c, swap 0 DO >r dup word
 1+ here r@ cmove r@ allot r>
 LOOP 2drop
 Does>  ( +n -- )
 count >r swap r@ * + r> type ;

-->






\ *** Block No. 144, Hexblock 90

\ dis text-tabellen            06mar86re

bl $39 3 | texttab .mnemonic
*by adc and asl bcc bcs beq bit bmi bne
bpl brk bvc bvs clc cld cli clv cmp cpx
cpy dec dex dey eor inc inx iny jmp jsr
lda ldx ldy lsr nop ora pha php pla plp
rol ror rti rts sbc sec sed sei sta stx
sty tax tay tsx txa txs tya
( +n -- )

Ascii / $E 1 | texttab .vor
   / /a/ /z/#/ / /(/(/z/z/ /(/


Ascii / $E 3 | texttab .nach
     /   /   /   /   /   /,x
 /,y /,x)/),y/,x /,y /   /)  /

-->






\ *** Block No. 145, Hexblock 91

\ dis 2u.r 4u.r                26may91pz

| : 4u.r ( u -)
     0 <# # # # # #> type ;

| : 2u.r ( u -)
     0 <# # # #> type ;


| : b@   >codeadr c@ ;
| : w@   >codeadr  @ ;


-->












\ *** Block No. 146, Hexblock 92

\ flushcode                    27may91pz

make flushcode     base push hex
 code[ codeoffset @ +
BEGIN dup pc u< WHILE
 cr dup 4u.r space dup b@ dup 2u.r space
 shortcode >r length @ dup
 IF over 1+ b@ 2u.r space THEN dup 2 =
 IF over 2+ b@ 2u.r space THEN
 2 swap - 3 * spaces
 r> .mnemonic space 1+
 mode @ dup .vor $C =
 IF dup b@ dup $80 and IF $100 - THEN
  over + 1+ 4u.r
 ELSE length @ dup 2 swap - 2* spaces
  ?dup
  IF 2 =
   IF   dup w@ 4u.r
   ELSE dup b@ 2u.r
 THEN THEN THEN mode @ .nach length @ +
REPEAT drop clearcode ;





\ *** Block No. 147, Hexblock 93



























\ *** Block No. 148, Hexblock 94



























\ *** Block No. 149, Hexblock 95

\ DIR: test                    26may91pz

..              -&149
codeoutput2       -&9
input              &1
:symtab            &3
errorhandler       &4
assembler          &5
codeoutput1       &13
savestack         &15
dumpsymtab        &17
:savestack        &18
:do$              &19













\ *** Block No. 150, Hexblock 96

\ testinput                    26feb91pz

| variable src | variable lpt
| variable inptr
~ variable comment-state
~ variable comment-line
~ variable line
| variable eof
~ -1 constant #eof

| : res-inptr  linebuf inptr ! ;

  : char>  ( -- c )  inptr @ c@
     ?dup 0= IF eof @ THEN ;
  : +char  ( -- )  1 inptr +! ;

  -->









\ *** Block No. 151, Hexblock 97

\   testinput                  13mar91pz

  : newline ( -- )
    1 line +!
    lpt @ dup 1023 >
       IF drop linebuf off  #eof eof !
       ELSE src @ block +
       linebuf 40 cmove
       linebuf 40 -trailing
       2dup cr ." src> " type cr
       + 0 swap c!
       41 lpt +! THEN
    res-inptr ;

  : openblk ( blk -- )
    line off  comment-state off eof off
    src ! 41 lpt !
    linebuf off  res-inptr ;

  : :input  4 openblk ;
    init: :input





\ *** Block No. 152, Hexblock 98

\ symtabtester                 26sep90pz

  : local ( obj -- )
     bl word putlocal 2! ;

  : global ( obj -- )
     bl word putglobal 2! ;



















\ *** Block No. 153, Hexblock 99

\ testerrorhandler             08mar91pz

~ : error ( errnum -- )
     errormessage swap string[]
     cr >string count type  cr ;

~ : ?error ( flag errnum -- )
    swap IF error ELSE drop THEN ;



~ : fatal ( errnum -- )
   error  true abort" fatal error" ;

~ : ?fatal ( flag errnum -- )
   swap IF fatal ELSE drop THEN ;










\ *** Block No. 154, Hexblock 9a

\ testassembler loadscreen     27may91pz

  1 6 +thru























\ *** Block No. 155, Hexblock 9b

\ testassembler: allgemeines   27may91pz

  : .lda# ( n )  ." lda #" u. cr ;
  : .pha         ." pha"      cr ;
  : .pha'        ." pha'"     cr ;
  : .pla         ." pla"      cr ;

  : .word ( n )  ." .word " u. cr ;
  : .byte ( c )  dup u. 0= IF cr THEN
                              ?cr ;
  : .jsr  ( n )  ." jsr  " u. cr ;
  : .jsr(zp)     ." jsr (zp)" cr ;
  : .rts         ." rts"      cr ;
  : .args        u. ." arguments" cr ;
  : .link# ( n ) ." link# " . cr ;
  : .lda-base    ." lda $base" cr ;
  : .pop-zp      ." pop $zp" cr ;
  : .lda-zp      ." lda $zp" cr ;
  : .sta-zp      ." sta $zp" cr ;

  : .shla        ." shla"     cr ;
  : .shra        ." shra"     cr ;
  : .and#255 ( ) ." and#255" cr ;
  : .switch      ." jsr $switch" cr ;


\ *** Block No. 156, Hexblock 9c

\   testassembler: 'sized'     27may91pz

  : .size ( n )  ." size: " . cr ;

  : .lda#.s ( n ) ." lda.s #" u. cr ;

  : .lda.s  ( n )  ." lda.s  " u. cr ;
  : .lda.s(zp)     ." lda.s (zp)" cr ;
  : .lda.s(base),# ( offs )
     ." lda.s (base),#" u.  cr ;

  : .sta.s  ( n )  ." sta.s  " u. cr ;
  : .sta.s(zp)     ." sta.s (zp)" cr ;
  : .sta.s(base),# ( offs )
     ." sta.s (base),#" u.  cr ;


  : .incr.s ( n )  ." incr.s " u.  cr ;
  : .2incr.s ( n ) ." 2incr.s " u. cr ;
  : .decr.s ( n )  ." decr.s " u.  cr ;
  : .2decr.s ( n ) ." 2decr.s " u. cr ;





\ *** Block No. 157, Hexblock 9d

\   testassembler: arithmetics 13mar91pz
\ arithmetik auf dem stapel

  : .not   ." not a"    cr ;
  : .neg   ." neg a"    cr ;
  : .inv   ." inv a"    cr ;

  : .mult  ." mult"      cr ;
  : .mult# ." mult# " u. cr ;
  : .div   ." div"       cr ;
  : .div#  ." div# " u.  cr ;
  : .#div  ." #div " u.  cr ;
  : .mod   ." mod"       cr ;
  : .mod#  ." mod# " u.  cr ;
  : .#mod  ." #mod " u.  cr ;

  : .add   ." add"       cr ;
  : .add#  ." add# " u.  cr ;
  : .sub   ." sub"       cr ;
  : .sub#  ." sub# " u.  cr ;
  : .#sub  ." #sub " u.  cr ;





\ *** Block No. 158, Hexblock 9e

\   testassembler: arithmetics 13mar91pz

  : .shl   ." shl"      cr ;
  : .shl#  ." shl# " u. cr ;
  : .#shl  ." #shl " u. cr ;
  : .shr   ." shr"      cr ;
  : .shr#  ." shr# " u. cr ;
  : .#shr  ." #shr " u. cr ;

  : .lt    ." lt"       cr ;
  : .lt#   ." lt# " u.  cr ;
  : .le    ." le"       cr ;
  : .le#   ." le# " u.  cr ;
  : .gt    ." gt"       cr ;
  : .gt#   ." gt# " u.  cr ;
  : .ge    ." ge"       cr ;
  : .ge#   ." ge# " u.  cr ;
  : .eq    ." eq"       cr ;
  : .eq#   ." eq# " u.  cr ;
  : .ne    ." ne"       cr ;
  : .ne#   ." ne# " u.  cr ;





\ *** Block No. 159, Hexblock 9f

\   testassembler: arithmetics 27may91pz

  : .and   ." and"      cr ;
  : .and#  ." and# " u. cr ;
  : .xor   ." xor"      cr ;
  : .xor#  ." xor# " u. cr ;
  : .or    ." or"       cr ;
  : .or#   ." or# " u.  cr ;

\\ 'unsized' in/decrements

  : .incr ( n )  ." incr " u.  cr ;
  : .2incr ( n ) ." 2incr " u. cr ;
  : .decr ( n )  ." decr " u.  cr ;
  : .2decr ( n ) ." 2decr " u. cr ;











\ *** Block No. 160, Hexblock a0

\   testassembler:jumps/labels 03mar94pz

\ variable >pc
\ : pc >pc @ ;
| : +pc   1 >pc +! ;

  : .jmp       ( adr -- )
     ." jmp " u. cr ;
  : .label      ( -- adr )
     pc dup ." *label*: " u. +pc cr ;
\ label 0 ist verboten wg. for & switch
  : .jmp-ahead ( -- adr )
     ." jmp ahead " pc dup u. +pc cr ;
  : .resolve-jmp ( adr -- )
     ." patch " u. cr ;

| : .beq    ." cmp #0: beq *+5 :" ;
| : .bne    ." cmp #0: bne *+5 :" ;

  : .jmz        .bne  .jmp ;
  : .jmn        .beq  .jmp ;

  : .jmz-ahead  .bne  .jmp-ahead ;
  : .jmn-ahead  .beq  .jmp-ahead ;


\ *** Block No. 161, Hexblock a1

                               27may91pz

























\ *** Block No. 162, Hexblock a2

\ testcodeoutput 1             25may91pz

make flushstatic ( -- )
   base push hex ." statics: "
   static> @ static[
   ?DO ?cr I c@ . LOOP ." ;end" cr
   static[ static> @ - static-offset +!
   clearstatic ;

make flushcode ( -- )
    ." ------ code flushed ------" cr ;















\ *** Block No. 163, Hexblock a3

                               26may91pz

























\ *** Block No. 164, Hexblock a4

\ testsavestack                26feb91pz

~ : +savestack  ?stack ;

~ : ?savestack  ?stack ;

~ : ?loadstack         ;

~ : -savestack         ;

















\ *** Block No. 165, Hexblock a5

\ teststorestring              23feb91pz

























\ *** Block No. 166, Hexblock a6

\ dumpsymtab                   08mar91pz

  : dumpglobals
     ]hash hash[ DO I @ ?dup
       IF dup count cr type bl emit
       count + 2@ u. u.
       ELSE cr ." ----" THEN
     2 +LOOP ;

  : dumplocals
     ]symtab locals> @ DO  cr
       I c@ /name >
          IF ." *** marke: " I c@ .  1
          ELSE I count type bl emit
          I count + 2@ u. u.
          I c@ 5 + THEN
       +LOOP ;









\ *** Block No. 167, Hexblock a7

\ testsavestack                18feb91pz

  : fillstack
    DO I ?savestack LOOP ;


  : readstack
    DO ?loadstack
    I - IF ." error" unloop exit THEN
    -1 +LOOP ;
















\ *** Block No. 168, Hexblock a8

\ test:do$:                    13mar91pz

| : test$[ ( -- )
     cr ." string: " ;

| : test$, ( c -- )
     ?cr  base push hex . ;

| : test]$ ( -- adr )
     cr $801 ;

~ do$: test$  ( -- adr )
        test$[ test$, test]$ ;













\ *** Block No. 169, Hexblock a9

k





          k





                    k





                              k






