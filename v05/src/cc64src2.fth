
\ *** Block No. 0, Hexblock 0

\ compiler (2)                 24aug94pz

.                  0
..                 0

loadscreen        &2

unravel           &5
codegen          &12
parser           &48
invoke          &100
pass2           &108
shell           &126













\ *** Block No. 1, Hexblock 1

\ memory settings              03sep94pz

  save
  $cbd0 set-himem
  $c000 ' limit >body !
  1024 1024 set-stacks




















\ *** Block No. 2, Hexblock 2

\ development loadscreen 2     24aug94pz

  onlyforth  decimal
\ : | ;   ( )
  compiler also definitions

  ^ codegen         load
  ^ parser          load
  ^ pass2           load
  ^ invoke          load

  onlyforth
~ vocabulary shell
  compiler also  shell definitions

  ^ shell           load










\ *** Block No. 3, Hexblock 3

\ testing loadscreen 2         13sep94pz

  onlyforth  decimal
  compiler also definitions
   blk/drv  err-blk ! \ for *compiler*

\needs ~  | : ~   ;
\needs .blk : .blk ( -)  blk @ ?dup  (
\ ) IF  ."  Blk " u. ?cr  THEN ;

' .blk Is .status

   12 load \     codegen
   48 load \     parser
  108 load \     pass2
  100 load \     invoke
    8 load \     savesystem

~ onlyforth   vocabulary shell
  compiler also  shell definitions

  126 load \     shell

  onlyforth    5 load


\ *** Block No. 4, Hexblock 4

\ endcompile loadscreen 2      07may95pz

  onlyforth  decimal  cr
  compiler also definitions

   blk/drv  err-blk ! \ for *compiler*

   12 load \     codegen
   48 load \     parser
  108 load \     pass2
  100 load \     invoke
    8 load \     savesystem

  onlyforth
  vocabulary shell
  compiler also  shell definitions

  126 load \     shell

  onlyforth

  ' noop is .status

  0 ink-pot !  15 ink-pot 2+ c!


\ *** Block No. 5, Hexblock 5

\ unravel                      20aug94pz

  : unravel rdrop rdrop rdrop
     cr ." trace dump on abort is :" cr
     BEGIN rp@ r0 @ - WHILE
      r> dup 8 u.r space
      2- @ >name .name cr REPEAT
     (error ;

   ' unravel  errorhandler !


\\ verwendung:

   ' unravel  errorhandler !


\\ abschalten:

   ' (error   errorhandler !






\ *** Block No. 6, Hexblock 6

\ kleinkram                    14mar91pz

  : ? @ . ;
  : _ nextword word. ;
  : id? id-buf count type ;
  : ty. ( type -- )
     %reference is? IF ." r " THEN
     %pointer   is? IF ." p " THEN
     %function  is? IF ." f " THEN
     %offset    is? IF ." o " THEN
     %stdfctn   is? IF ." s " THEN
     %extern    is? IF ." e " THEN
     %proto     is? IF ." t " THEN
     is-int? IF ." int " ELSE ." char "
             THEN
    u. ;
  variable #l
  : dumplist ( list -- )  #l off
     BEGIN @ ?dup WHILE dup u. ." : "
     dup 2+ dup @ u. 2+ @ u. cr 1 #l +!
     REPEAT ." length:" #l @ u. ;
  : init-var $8000 >staticadr
             tos-offs off
             1 >pc ! ;
  init: init-var

\ *** Block No. 7, Hexblock 7

\ testsequenz                  09apr94pz

[]init'd off
#inits off
initializer
cr []init'd ?
#inits ?
cr .s
clearstack
_
















\ *** Block No. 8, Hexblock 8

\ savesystem                   03sep94pz

\needs savesystem (
\\ )

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








\ *** Block No. 9, Hexblock 9

                               01mar94pz

























\ *** Block No. 10, Hexblock a

                               01mar94pz

























\ *** Block No. 11, Hexblock b

                               01mar94pz

























\ *** Block No. 12, Hexblock c

\ codegen loadscreen           21sep94pz


  .( module codegen )

  1 25 +thru

  cr


















\ *** Block No. 13, Hexblock d

\ codegen: objects             13jan91pz

\ an object is 8 or 16 bit numerical
\ value on the runtime-stack.
\ at compile time it is represented by
\ a 16 bit desciptor and a 16 bit
\ value  ( obj ) = ( val desc ).

\ the descriptor constists of data type

| 1 constant %int

\ and object type

~  $100 constant %reference \ provided
~  $200 constant %pointer   \ by the
~  $400 constant %function  \ symbol
~  $800 constant %offset    \ table
~ $1000 constant %stdfctn   \
~ $2000 constant %extern    \
~ $4000 constant %proto

| $8000 constant %constant  \ generated
\ internally for optimization.


\ *** Block No. 14, Hexblock e

\   codegen: objects           26sep90pz

\  handle data type
~ : set-char     %int not and ;
~ : set-int      %int or ;
     ( n1 -- n2 )

~ : is-char?     dup %int and 0= ;
~ : is-int?      is-char? 0= ;
     ( n -- n flag )

\  handle object type
~ : set          or ;
~ : clr          not and ;
     ( n1 mask -- n2 )

~ : is?          2dup xor and 0= ;
~ : isn't?       over and 0= ;
     ( n mask -- n flag )
     ( flag = true <=> alle gesetzten
       mask-bits in n gesetzt bzw.
       geloescht )




\ *** Block No. 15, Hexblock f

\   codegen: objects           11mar91pz

| : size? ( obj -- obj size )
     %pointer %function + isn't? >r
     is-char? r> and 2+ ;

\ size? und .size machen nur bei
\ %reference-objekten sinn !


~ 0 set-int  constant %default
  ( default data type, e.g type of
    a multipication's result )

  0 set-int %reference %extern + set
~ constant %global
  0 set-int %reference %offset + set
~ constant %local
  ( default definition types )

~ $0701 constant %cond.mask
~ $9f01 constant %expr.mask
~ $3f01 constant %decl.mask
  ( masks for type comparisons )


\ *** Block No. 16, Hexblock 10

\ codegen: reference/value     26sep90pz

| defer 'value      ( obj1 -- obj2 )

| : value ( obj1 -- obj2 )
   %reference is?
      IF 'value  %reference clr
      %function %pointer + isn't?
         IF set-int THEN THEN ;

| : reference ( obj1 -- obj2 )
   %reference is?
      IF %reference clr
      ELSE *noref* error THEN ;












\ *** Block No. 17, Hexblock 11

\ codegen: constant, doit      18apr94pz

| variable a-used

| : require-accu
     a-used @ IF .pha' THEN
     a-used on ;

~ : release-accu
     a-used off ;

| : non-constant ( obj1 -- obj2 )
     %constant is?  IF %constant clr
       require-accu  over .lda# THEN ;

   init: release-accu


| variable vector

| : doit ( n -- )
     vector @ + perform ;
  ( for unop, incop and do-binop, who
    all use vectors )


\ *** Block No. 18, Hexblock 12

\ codegen: combined type tests 01mar91pz

| : pointer? ( type -- type flag )
     %pointer is? >r %function isn't?
     r> and ;
  ( for do-add and do-sub )

| : int-pointer? ( type -- type flag )
     pointer? >r is-int? r> and ;
  ( for incop )
  ( both for pointer scaling )

| : array? ( type -- type flag )
     %reference %function + isn't? >r
     %pointer is? r> and ;
  ( for definitions )

| : function? ( type -- type flag )
     %function is? >r %reference isn't?
     r> and ;
  ( for prepare-call and definitions )





\ *** Block No. 19, Hexblock 13

\ codegen: atom                18apr94pz

| : do-numatom ( val -- obj )
     [ %default  %constant set ]
     literal ;

| : do-stringatom ( adr -- obj )
     require-accu  .lda#
     [ %default %pointer set set-char ]
     0  literal ;


| : do-lda(a) ( obj1 -- obj2 )
     size? .size
     %constant is?
        IF   require-accu
        over .lda.s  %constant clr
        ELSE .sta-zp .lda.s(zp) THEN ;








\ *** Block No. 20, Hexblock 14

\   codegen: atom              27may91pz

| : do-lda(base),# ( obj1 -- obj2 )
     %offset isn't? *compiler* ?fatal
     require-accu  size? .size
     over .lda.s(base),#
     %offset clr ;

| : do-idatom ( name -- obj )
     dup findlocal ?dup
        IF nip
        ELSE findglobal ?dup 0=
           IF *undef* error
           0 do-numatom exit THEN
        THEN 2@
     %expr.mask and
     %offset isn't?
        IF ['] do-lda(a)  IS 'value
        %constant set  exit THEN
     %reference is?
        IF ['] do-lda(base),# IS 'value
        ELSE require-accu  .lda-base
        over .add#  %offset clr THEN ;



\ *** Block No. 21, Hexblock 15

\ codegen: primary             22aug94pz

| : put-std-argument ( obj -- )
     value non-constant 2drop ;

| : drop-std-argument ( obj -- )
     value non-constant 2drop .pla ;

| : do-std-call ( obj1 -- obj2 )
     %stdfctn %constant + clr
     over .jsr ;















\ *** Block No. 22, Hexblock 16

\   codegen: primary           27may91pz

| : prepare-call ( obj1 -- obj2 args )
     function? not *nofunc* ?error
     value 0 ;

| : put-argument  ( args obj -- args' )
     value  non-constant  2drop
     2 .size
     2 dyn-allot .sta.s(base),#
     release-accu  2- ;















\ *** Block No. 23, Hexblock 17

\   codegen: primary           27may91pz

| : do-call ( obj2 args -- obj3 )
     dyn-allot tos-offs @ - 2/ >r
     %constant isn't?
     IF .sta-zp ELSE require-accu THEN
     tos-offs @ .link#
     r> .args
     %constant is?
        IF over .jsr
        ELSE .jsr(zp) THEN
     tos-offs @ negate .link#
     %constant %function + clr ;













\ *** Block No. 24, Hexblock 18

\   codegen: primary           23feb91pz

| : do-pointer ( obj1 -- obj2 )
   %reference is? >r  value
   %function is?
      IF r>
         IF %reference clr
         ELSE drop %default
         *novector* error THEN
      ELSE rdrop  %pointer isn't?
         *noptr* ?error
      %pointer clr  %reference set
      ['] do-lda(a) IS 'value
      THEN ;












\ *** Block No. 25, Hexblock 19

\ codegen: unary               27may91pz

| : do-adress ( obj1 -- obj2 )
   reference
   %offset is?
      IF require-accu
      .lda-base  over .add#
      %offset clr THEN
   size? 1- IF set-int THEN
   %pointer set  %function clr ;


| : unop ( cfa2 cfa0 -- )
     create , ,
    does> ( obj1 pfa -- obj2 ) vector !
     value  %constant is? nip
        IF 2 doit
        %default  %constant set
        ELSE 0 doit %default THEN ;

| ' negate  ' .neg  unop do-neg
| ' 0=      ' .not  unop do-not
| ' not     ' .inv  unop do-inv



\ *** Block No. 26, Hexblock 1a

\   codegen: unary             18apr94pz

| : incop ( cfa6 cfa4 cfa2 cfa0 -- )
     create , , , ,
    does> ( obj1 pfa -- obj2 ) vector !
     reference  size? .size
     %constant is?
        IF %constant clr  require-accu
        int-pointer? 2 and doit
     ELSE %offset is?
        IF %offset clr  require-accu
        int-pointer? 1 and 1+
        2 pick  dup .lda.s(base),#
        swap  6 doit
     ELSE .sta-zp  .lda.s(zp)
        int-pointer? 1 and 1+  4 doit
     THEN THEN
     %function is?
        IF drop %default THEN ;

\\ the complications are due to the
   different adressing modes and to
   the scaling of pointers.



\ *** Block No. 27, Hexblock 1b

\   codegen: unary             27may91pz

| : ++x0 over dup .incr.s   .lda.s ;
| : ++x2 over dup .2incr.s  .lda.s ;
| : ++x4 .add#  .sta.s(zp) ;
| : ++x6 .add#  .sta.s(base),# ;

| : --x0 over dup .decr.s   .lda.s ;
| : --x2 over dup .2decr.s  .lda.s ;
| : --x4 .sub#  .sta.s(zp) ;
| : --x6 .sub#  .sta.s(base),# ;

| : x++0 over dup .lda.s  .incr.s ;
| : x++2 over dup .lda.s  .2incr.s ;
| : x++4 .pha .add#  .sta.s(zp) .pla ;
| : x++6 .pha .add#  .sta.s(base),#
                                .pla ;

| : x--0 over dup .lda.s  .decr.s ;
| : x--2 over dup .lda.s  .2decr.s ;
| : x--4 .pha .sub#  .sta.s(zp) .pla ;
| : x--6 .pha .sub#  .sta.s(base),#
                                .pla ;



\ *** Block No. 28, Hexblock 1c

\   codegen: unary             27sep90pz

   ' ++x6 ' ++x4 ' ++x2 ' ++x0
| incop do-preinc

   ' --x6 ' --x4 ' --x2 ' --x0
| incop do-predec

   ' x++6 ' x++4 ' x++2 ' x++0
| incop do-postinc

   ' x--6 ' x--4 ' x--2 ' x--0
| incop do-postdec













\ *** Block No. 29, Hexblock 1d

\ codegen: binary              11sep94pz

| variable typ

| : setconst ( -- )
     typ @  %constant set  typ ! ;

    ' setconst ' swap ' noop ' drop
| create const-vec    , , , ,

| : do-binop ( obj1 obj2 vec -- obj3 )
     vector !
     %constant is? 2 and >r drop  swap
     %constant is? 4 and r> or >r drop
     const-vec r@ + perform
     r> doit  typ @ ;










\ *** Block No. 30, Hexblock 1e

\   codegen: binary            11sep94pz

| : do-shla  ( obj1 -- obj2 )
     %constant is?
      IF swap 2* swap ELSE .shla THEN ;

| : do-shra  ( obj1 -- obj2 )
     %constant is?
      IF swap 2/ swap ELSE .shra THEN ;

| create add-vec
  ' + ' .add# ' .add# ' .add , , , ,

| : do-add ( obj1 obj2 -- obj3 )
     2swap pointer?
        IF dup %constant clr typ !
        is-int? >r  2swap r>
           IF do-shla THEN
        ELSE %default typ ! THEN
     add-vec do-binop ;

\\ complications are due to pointer
   scaling.



\ *** Block No. 31, Hexblock 1f

\   codegen: binary            11sep94pz

| variable shra-flag
| create sub-vec
  ' - ' .#sub ' .sub# ' .sub , , , ,

| : do-sub ( obj1 obj2 -- obj3 )
     shra-flag off  %default typ !
     2swap pointer?
        IF dup >r 2swap pointer?
           IF is-int? r> is-int?
           nip and
              IF shra-flag on THEN
           ELSE r> is-int?
           swap %constant clr  typ !
              IF do-shla THEN
           THEN
        ELSE 2swap THEN
     sub-vec do-binop
     shra-flag @ IF do-shra THEN ;

\\ complications are due to pointer
   scaling.



\ *** Block No. 32, Hexblock 20

\   codegen: binary            12sep90pz

| : binop ( cfa3 cfa2 cfa1 cfa0 -- )
     create , , , ,
    does>   ( obj1 obj2 vec -- obj3 )
     %default typ !  do-binop ;

   ' * ' .mult# ' .mult# ' .mult
| binop do-mult
   ' / ' .#div ' .div# ' .div
| binop do-div
   ' mod ' .#mod ' .mod# ' .mod
| binop do-mod
   ' and ' .and# ' .and# ' .and
| binop do-and
   ' xor ' .xor# ' .xor# ' .xor
| binop do-xor
   ' or ' .or# ' .or# ' .or
| binop do-or







\ *** Block No. 33, Hexblock 21

\   codegen: binary            03sep94pz

\ > und < sollten 0 oder -1 ergeben !

~ : <=  swap > ;
~ : >=  swap < ;
~ : !=  = 0= ;

   ' < ' .gt# ' .lt# ' .lt
| binop do-lt
   ' > ' .lt# ' .gt# ' .gt
| binop do-gt
   ' <= ' .ge# ' .le# ' .le
| binop do-le
   ' >= ' .le# ' .ge# ' .ge
| binop do-ge
   ' = ' .eq# ' .eq# ' .eq
| binop do-eq
   ' != ' .ne# ' .ne# ' .ne
| binop do-ne






\ *** Block No. 34, Hexblock 22

\   codegen: binary            27sep90pz

~ : << ( n1 n2 -- n3 )
     0 ?DO 2* LOOP ;
~ : >> ( n1 n2 -- n3 )
     0 ?DO 2/ LOOP ;

   ' << ' .#shl ' .shl# ' .shl
| binop do-shl
   ' >> ' .#shr ' .shr# ' .shr
| binop do-shr















\ *** Block No. 35, Hexblock 23

\   codegen: binary            22feb91pz

| : do-l-and.1 ( obj -- adr )
     value non-constant  2drop
     .jmz-ahead
     release-accu ;

| : do-l-and.2 ( adr obj1 -- obj2 )
     value non-constant  2drop
     .resolve-jmp
     0 %default ;

| : do-l-or.1 ( obj -- )
     value non-constant  2drop
     .jmn-ahead
     release-accu ;

| ' do-l-and.2 ALIAS do-l-or.2








\ *** Block No. 36, Hexblock 24

\   codegen: conditional       22feb91pz

| : is0? ( obj -- obj flag )
     %constant is? >r over 0= r> and ;

| : do-cond1 ( obj1 -- adr1 )
     value non-constant
     2drop  release-accu
     .jmz-ahead ;

| : do-cond2 ( adr1 obj2 -- obj' adr2 )
     value is0? -rot non-constant nip
     rot .jmp-ahead swap .resolve-jmp
     release-accu ;

| : do-cond3 ( obj' adr2 obj3 -- obj )
     value is0? -rot non-constant nip
     rot .resolve-jmp
     2 pick over xor %cond.mask and 0=
        IF 2drop exit THEN
     over   IF 2drop exit THEN
     3 pick IF nip nip exit THEN
     2drop drop %default
     *!=type* error ;


\ *** Block No. 37, Hexblock 25

\   codegen: assign            27may91pz

| : prepare-asgnop ( obj1 -- obj2 obj3 )
     reference
     %constant %offset + isn't?
        IF .pha THEN
     2dup %reference set  value ;

| : prepare-assign ( obj1 -- obj2 )
     reference ;

| : do-assign ( obj1 obj2 -- obj1 )
     ( value ) non-constant  2drop
     ( 'obj2' is always 'value' )
     size? dup .size  1 =
        IF .and#255 THEN
     %constant is?
        IF %constant clr
        over .sta.s
        ELSE %offset is?
           IF %offset clr
           over .sta.s(base),#
           ELSE .pop-zp .sta.s(zp) THEN
        THEN ;


\ *** Block No. 38, Hexblock 26

                               01mar94pz

























\ *** Block No. 39, Hexblock 27

                               01mar94pz

























\ *** Block No. 40, Hexblock 28

                               01mar94pz

























\ *** Block No. 41, Hexblock 29

                               01mar94pz

























\ *** Block No. 42, Hexblock 2a

                               01mar94pz

























\ *** Block No. 43, Hexblock 2b

                               01mar94pz

























\ *** Block No. 44, Hexblock 2c

                               01mar94pz

























\ *** Block No. 45, Hexblock 2d

                               01mar94pz

























\ *** Block No. 46, Hexblock 2e

                               01mar94pz

























\ *** Block No. 47, Hexblock 2f

                               01mar94pz

























\ *** Block No. 48, Hexblock 30

\ parser loadscreen            21sep94pz

  .( module parser: ) cr

| : teststack  ( -- )
     here $80 + sp@ u> *stack* ?fatal
     up@ udp @ + $40 + rp@ u>
                      *rstack* ?fatal ;

  .( submodule expression )
  1 13 +thru  cr   \ expression

  .( submodule statement )
 14 24 +thru  cr   \ statement

  .( submodule definition )
 25 48 +thru  cr   \ definition









\ *** Block No. 49, Hexblock 31

\ parser: tools                22feb91pz

| : comes? ( word wordtype -- flag )
    nextword dnegate d+ or
    IF backword false ELSE true THEN ;

| : comes-a? ( wordtype -- word true )
             ( wordtype -- false )
    nextword rot = dup not
    IF nip backword THEN ;

| : expect ( word wordtype -- )
    2dup comes?
       IF 2drop
       ELSE *expected* error word.
       THEN ;

\ : skipword ( -- )
\    *ignored* error nextword word. ;







\ *** Block No. 50, Hexblock 32

\ parser: atom                 13sep94pz

| : cp$[ ( -- jmp adr )
     .jmp-ahead  .label ;

| : cp]$ ( jmp adr -- adr )
     swap .resolve-jmp ;

~ do$: compile$  ( -- adr )
        cp$[ .byte cp]$ ;


| : atom ( -- obj )
   #number# comes-a?
      IF do-numatom  exit THEN
   #id#     comes-a?
      IF do-idatom   exit THEN
   #string# comes-a?
      IF drop compile$
      do-stringatom  exit THEN
   ." a value" *expected* error
   0 do-numatom ;




\ *** Block No. 51, Hexblock 33

\ parser: primary              15mar91pz

| doer expression
| doer assign

| : primary[] ( obj1 -- obj2 )
   value
   expression value  do-add
   do-pointer
   ascii ] #char# expect ;
















\ *** Block No. 52, Hexblock 34

\   parser: primary            22feb91pz

| : std-arguments ( -- )
     assign put-std-argument
     BEGIN ascii , #char# comes? WHILE
     assign drop-std-argument REPEAT ;

| : arguments  ( -- )
     BEGIN assign put-argument
     ascii , #char# comes? not UNTIL ;

| : primary() ( obj1 -- obj2 )
     %stdfctn is?
        IF ascii ) #char# comes?
           IF 0 do-numatom
           ELSE std-arguments
           ascii ) #char# expect THEN
        do-std-call
        ELSE prepare-call
        ascii ) #char# comes? not
           IF arguments
           ascii ) #char# expect THEN
        do-call THEN ;



\ *** Block No. 53, Hexblock 35

\   parser: primary            11sep94pz

| : primary ( -- obj )
     teststack
     ascii ( #char# comes?
        IF expression
        ascii ) #char# expect
        ELSE atom THEN
     BEGIN mark >r
     ascii ( #char# comes?
        IF primary() THEN
     %stdfctn is?
        IF drop %default THEN
     ascii [ #char# comes?
        IF primary[] THEN
     r> advanced? not UNTIL ;










\ *** Block No. 54, Hexblock 36

\ parser: unary                22feb91pz

| : unary ( -- obj )  recursive

   #oper# comes-a? IF
    <-> case? IF unary do-neg exit THEN
    <!> case? IF unary do-not exit THEN
    <inv> case?
          IF unary do-inv     exit THEN
    <*> case?
          IF unary do-pointer exit THEN
    <and> case?
          IF unary do-adress  exit THEN
    <++> case?
          IF unary do-preinc  exit THEN
    <--> case?
          IF unary do-predec  exit THEN
    drop  backword THEN
   primary
   #oper# comes-a? IF
    <++> case? IF do-postinc  exit THEN
    <--> case? IF do-postdec  exit THEN
    drop  backword THEN ;



\ *** Block No. 55, Hexblock 37

\ parser: binary               06mar91pz

| : comes-op? ( tab -- cfa true )
              ( tab -- false )
     #oper# comes-a?
        IF swap  dup 2+ swap @ bounds
        DO dup I @ =
          IF drop  I 2+ @  true
          UNLOOP exit THEN
        4 +LOOP
        backword THEN
     drop  false ;

| : binary  ( tab -- )
    create , dup 4 * ,  0
     DO swap , , LOOP
    does>   ( tab -- obj )
     dup @ execute
     BEGIN 2 pick 2+ comes-op? WHILE >r
     value  2 pick @ execute value
     r> execute REPEAT
     2 roll drop ;

\\ fuer assign wird 'von hand' eine
   'comes-op?'-tabelle angelegt !

\ *** Block No. 56, Hexblock 38

\   parser: binary             08apr90pz

  <*>   ' do-mult
  </>   ' do-div
  <%>   ' do-mod
  3  ' unary   | binary product

  <+>   ' do-add
  <->   ' do-sub
  2  ' product | binary sum

  <<<>  ' do-shl
  <>>>  ' do-shr
  2  ' sum     | binary shift

  <<>   ' do-lt
  <<=>  ' do-le
  <>>   ' do-gt
  <>=>  ' do-ge
  4  ' shift   | binary comp

  <==>  ' do-eq
  <!=>  ' do-ne
  2  ' comp    | binary equal


\ *** Block No. 57, Hexblock 39

\   parser: binary             09oct90pz

  <and> ' do-and
  1  ' equal   | binary bit-and

  <xor> ' do-xor
  1  ' bit-and | binary bit-xor

  <or>  ' do-or
  1  ' bit-xor | binary bit-or

| : l-and ( -- obj )
     bit-or
     BEGIN  <l-and> #oper# comes? WHILE
     do-l-and.1  bit-or
     do-l-and.2  REPEAT ;

| : l-or ( -- obj )
     l-and
     BEGIN  <l-or> #oper# comes? WHILE
     do-l-or.1  l-and
     do-l-or.2  REPEAT ;




\ *** Block No. 58, Hexblock 3a

\   parser: binary             07apr90pz

| : conditional ( -- obj )
     l-or
     ascii ? #char# comes?
        IF do-cond1
        recursive conditional
        do-cond2
        ascii : #char# expect
        recursive conditional
        do-cond3 THEN ;















\ *** Block No. 59, Hexblock 3b

\ parser: assign               06mar91pz

| create assign-oper  11  4 * ,
  <=>      0          swap  , ,
  <*=>   ' do-mult    swap  , ,
  </=>   ' do-div     swap  , ,
  <%=>   ' do-mod     swap  , ,
  <+=>   ' do-add     swap  , ,
  <-=>   ' do-sub     swap  , ,
  <<<=>  ' do-shl     swap  , ,
  <>>=>  ' do-shr     swap  , ,
  <and=> ' do-and     swap  , ,
  <xor=> ' do-xor     swap  , ,
  <or=>  ' do-or      swap  , ,

\\ hier wird eine tabelle angelegt,
   die mit dem format der 'binary'-
   tabellen uebereinstimmt, also
   mit 'comes-op?' durchsucht wird.







\ *** Block No. 60, Hexblock 3c

\   parser: assign             08apr90pz

  make assign ( -- obj )
     conditional
     assign-oper comes-op?
        IF ?dup
           IF >r  prepare-asgnop
           recursive assign value
           r> execute
           ELSE prepare-assign
           recursive assign value THEN
        do-assign THEN ;














\ *** Block No. 61, Hexblock 3d

\ parser: expression           29oct90pz

  make expression  ( -- obj )
   assign
   ascii , #char# comes?
      IF value non-constant
      BEGIN 2drop release-accu
      assign value non-constant
      ascii , #char# comes? 0= UNTIL
      THEN ;


~ : constant-expression ( -- val )
     assign value  %constant isn't?
     *noconst* ?error  drop ;

~ : expression  ( -- )
     expression value non-constant
     2drop release-accu ;







\ *** Block No. 62, Hexblock 3e

\ parser: statement            12mar91pz

~ doer compound
| doer statement

| : expect';'  ascii ; #char# expect ;

| : expression-stmt ( -- )
      expression  expect';' ;

| : return-stmt ( -- )
      ascii ; #char# comes? not
         IF expression-stmt THEN
      .rts ;












\ *** Block No. 63, Hexblock 3f

\   parser: statement          22feb91pz

| : (expression)  ( -- )
     ascii ( #char# expect
     expression
     ascii ) #char# expect ;

| : if-stmt  ( -- )
     (expression)
     .jmz-ahead
     statement
     <else> #keyword# comes?
        IF .jmp-ahead swap .resolve-jmp
        statement THEN
     .resolve-jmp ;











\ *** Block No. 64, Hexblock 40

\   parser: statement          12mar91pz

| : ?drop&exit ( n flag -- n / -- )
      IF drop rdrop THEN ;

| : new  ( list -- )
     heap> ?dup 0= ?drop&exit
     dup 2+ off  swap hook-into ;

| : resolve  ( list -- )
     BEGIN dup hook-out  dup >heap
     2+ @ ?dup WHILE
     .resolve-jmp REPEAT drop ;













\ *** Block No. 65, Hexblock 41

\   parser: statement          12mar91pz

| variable breaks
| variable conts

| : another  ( list -- )
     dup @ 0= IF *ill-brk* error
              drop exit THEN
     heap> ?dup 0= ?drop&exit
     .jmp-ahead over 2+ !
     swap hook-into ;

| : break-stmt ( -- )
     breaks another  expect';' ;

| : continue-stmt ( -- )
     conts another  expect';' ;

~ : init-breaks  breaks off conts off ;
     init: init-breaks






\ *** Block No. 66, Hexblock 42

\   parser: statement          18apr94pz

| variable switch-state ( 0/-1/def.adr)
| variable cases

~ : init-switch   switch-state off
     cases off ;
    init: init-switch

| : case-stmt ( -- )
     constant-expression
     ascii : #char# expect
     switch-state @ 0=   IF drop
        *noswitch* error exit THEN
     heap> ?dup 0= ?drop&exit
     dup  cases hook-into
     2+ .label over !  2+ ! ;

| : default-stmt ( -- )
     ascii : #char# expect
     switch-state @ 1+
        IF *ill-default* error
        ELSE .label switch-state !
        THEN ;


\ *** Block No. 67, Hexblock 43

\   parser: statement          27may91pz

| : cases-resolve ( -- )
     BEGIN cases hook-out  dup >heap
     2+ dup @ ?dup WHILE
     .word 2+ @ .word REPEAT
     drop  0 .word ;

| : switch-stmt  ( -- )
     switch-state @ switch-state on
     breaks new  cases new
     (expression)  .jmp-ahead
     statement
     .jmp-ahead  swap  .resolve-jmp
     .switch  cases-resolve
     switch-state @ not ?dup
        IF not .jmp THEN  \ default
     .resolve-jmp  breaks resolve
     switch-state ! ;

\\ $switch tay:pla:ina:sta zp:tya:ldy#0
   [[ pha:lda(zp):ne?[[ sta vec:winc zp
    pla:cmp(zp):eq?[ jmp(vec) ]?
    winc zp ]]? winc zp:jmp(zp)


\ *** Block No. 68, Hexblock 44

\   parser: statement          22feb91pz

| : do-stmt  ( -- )
     breaks new  conts new
     .label  statement  conts resolve
     <while> #keyword# expect
     (expression)  .jmn
     breaks resolve  expect';' ;

| : while-stmt  ( -- )
     breaks new  conts new
     .label  (expression)
     .jmz-ahead
     statement  conts resolve
     swap .jmp  .resolve-jmp
     breaks resolve ;










\ *** Block No. 69, Hexblock 45

\   parser: statement          22feb91pz

\ : 1st-expression  ( -- )
\    ascii ; #char# comes? not
\      IF expression  expect';' THEN ;

| : 2nd-expression? ( -- flag )
     ascii ; #char# comes? not dup
       IF expression  expect';' THEN ;

| : 1st-expression  ( -- )
     2nd-expression? drop ;

| : 3rd-expression  ( -- )
     ascii ) #char# comes? not
        IF expression
        ascii ) #char# expect THEN ;









\ *** Block No. 70, Hexblock 46

\   parser: statement          22feb91pz

| : for-stmt ( -- )
     breaks new  conts new
     ascii ( #char# expect
     1st-expression
     .label                     \ X
     2nd-expression? dup >r     \ ^
        IF .jmn-ahead ( true )  \ ^O
           .jmp-ahead ( false ) \ ^YO
        ELSE .jmp-ahead 0 THEN  \ ^OO
     .label                     \ ^YYX
     3rd-expression             \ ^YY^
     3 roll .jmp                \ OYY^
     rot .resolve-jmp           \  XY^
     statement                  \   Y^
     conts resolve              \   Y^
     .jmp                       \   YO
     r> IF .resolve-jmp         \   X
        ELSE drop THEN
     breaks resolve ;





\ *** Block No. 71, Hexblock 47

\   parser: statement          12mar91pz

~ : statement? ( -- flag )  true
  #keyword# comes-a? IF
  <break> case? IF break-stmt exit THEN
  <cont> case?
             IF continue-stmt exit THEN
  <if> case?    IF if-stmt    exit THEN
  <do> case?    IF do-stmt    exit THEN
  <while> case? IF while-stmt exit THEN
  <for> case?   IF for-stmt   exit THEN
  <case> case?  IF case-stmt  exit THEN
  <default> case?
             IF default-stmt  exit THEN
  <switch> case?
             IF switch-stmt   exit THEN
  <return> case?
             IF return-stmt   exit THEN
  drop  backword THEN

 [ 0 ?pairs





\ *** Block No. 72, Hexblock 48

\   parser: statement          11sep94pz

 0 ]
  #char# comes-a? IF
  ascii { case? IF compound   exit THEN
  ascii ; case? IF            exit THEN
  ascii } case? IF backword  not
                              exit THEN
  drop  backword THEN  drop
  mark expression-stmt advanced? ;


 make statement ( -- )
  teststack
  statement? not
     IF *expected* error
     ." a statement" THEN ;









\ *** Block No. 73, Hexblock 49

\ parser: declaration basics   14mar91pz

| variable #/obj
| variable []dim'd
| variable #inits
| variable []init'd

| variable extern

| : >type  ( desc -- desc.type )
          ; immediate

\ haengt von der wirkungsweise von
\ 2@ u. 2! ab, mit denen normalerweise
\ auf die symboltabelle zugegriffen
\ wird.










\ *** Block No. 74, Hexblock 4a

\   parser: declaration basics 14mar91pz

~ variable function :does> 0 ;

~ : defined   swap ! ;
~ : defined?  swap @ = ;

\   function [ not ] defined
\   function [ not ] defined?

















\ *** Block No. 75, Hexblock 4b

\   parser: type-specifiers    14mar91pz

| : type-name? ( type -- type' flag )
     <char> #keyword# comes?
        IF set-char true
        ELSE <int> #keyword# comes?
           IF set-int true
           ELSE false THEN THEN ;

| : register? ( type -- type' flag )
     <register> #keyword# comes?
        IF ( %register set ) true
        ELSE false THEN ;

| : extern? ( type -- type' flag )
     <extern> #keyword# comes?
        IF %extern set  %offset clr
           extern on  true
        ELSE false THEN ;







\ *** Block No. 76, Hexblock 4c

\   parser: type-specifiers    14mar91pz

| : range? ( type -- type' flag )
     extern? ?dup ?exit
     <static> #keyword# comes?
        IF %extern clr true
        ELSE false THEN ;

| : class? ( type -- type' flag )
     register? ?dup ?exit
     extern?   ?dup ?exit
     <auto> #keyword# comes?
        IF true exit THEN
     <static> #keyword# comes?
        IF %offset clr true
        ELSE false THEN ;










\ *** Block No. 77, Hexblock 4d

\   parser: type-specifiers    11sep94pz

| defer 'class?

| : or-type: ( cfa -- )  create ,
    does> ( type pfa -- type' flag )
     @ IS 'class?   extern off
     'class?
        IF type-name? drop  true
        ELSE type-name?
           IF 'class? drop  true
           ELSE false THEN THEN ;

| ' class? or-type: class-or-type?
| ' range? or-type: range-or-type?
| ' register? or-type: register-or-type?










\ *** Block No. 78, Hexblock 4e

\   parser: declarator         08mar91pz

| create id-buf /id 1+ allot

| : handle-id  ( -- )
     id-buf off  #id# comes-a?
        IF id-buf over c@ 1+ cmove
        ELSE *expected* error
        ." identifier" THEN ;


| : [parameters]) ( -- )
     tos-offs off
     ascii ) #char# comes? not
        IF BEGIN #id# comes-a?
           IF putlocal
           2 dyn-allot %local  rot 2!
           ELSE *expected* error
           ." identifier" THEN
        ascii , #char# comes? not UNTIL
        ascii ) #char# expect THEN ;





\ *** Block No. 79, Hexblock 4f

\   parser: declarator         14mar91pz

| : handle-function ( type -- type' )
     function?
        IF unnestlocal THEN
     %function is?
        *double-func* ?error
     %function set
     %pointer is?
        IF []dim'd @ *???* ?error
        []dim'd off  1 #/obj !
        %pointer clr  %reference set
        ELSE %reference clr THEN
     function?
        IF nestlocal [parameters])
        ELSE ascii ) #char# expect
        THEN ;









\ *** Block No. 80, Hexblock 50

\   parser: declarator         08mar91pz

| : set-pointer ( type -- type' )
     %pointer is?  *double-ptr* ?error
     %pointer set ;

| : handle-array ( type -- type' )
     ascii ] #char# comes? not
        IF %function is? >r
        constant-expression r>
           IF drop *???* error
           ELSE #/obj ! []dim'd on THEN
        ascii ] #char# expect THEN
     set-pointer  %function isn't?
        IF %reference clr THEN ;

\\ frueher:
     set-pointer  %function is?
        IF ascii ] #char# expect
        ELSE %reference clr
        ascii ] #char# comes? not
           IF constant-expression
           #/obj !  []dim'd on
           ascii ] #char# expect THEN
        THEN ;

\ *** Block No. 81, Hexblock 51

\   parser: declarator         06mar91pz

| : (declarator ( type -- type' )
     1 #/obj !  []dim'd off
    false BEGIN <*> #oper# comes? WHILE
     *double-ptr* ?error true REPEAT >r
     ascii ( #char# comes?
        IF recursive (declarator
           ascii ) #char# expect
        ELSE handle-id THEN
     BEGIN mark >r
     ascii [ #char# comes?
        IF handle-array THEN
     ascii ( #char# comes?
        IF handle-function THEN
     r> advanced? not UNTIL
     r> IF set-pointer THEN ;

| defer 'declarator ( type' -- )

| : declarator ( type -- )
     (declarator 'declarator ;




\ *** Block No. 82, Hexblock 52

\   parser: declarator         12mar91pz

| variable (1st
| : 1st  (1st on ;
| : 2nd  (1st off ;
| : 1st? (1st @ ;


| : declarator-list';' ( type -- )
     >r
     function not defined
     r@ 1st declarator
     function defined?
        IF rdrop exit THEN
     BEGIN ascii , #char# comes? WHILE
     r@ 2nd declarator REPEAT
     rdrop expect';' ;









\ *** Block No. 83, Hexblock 53

\   parser: initializer        11sep94pz

| : 1more ( n -- n )
     teststack  1 #inits +! ;

| : nomore ( n -- )  drop ;

| defer '1more

| : ?1more  ( flag -- )
        IF ['] 1more
        ELSE *initer* error
        ['] nomore THEN
     IS '1more ;

| : >inittype ( type -- inittype )
     ( bit 0: int     bit 1: array   )
     ( bit 2: offset  bit 3: []dim'd )
     is-int? 1 and >r array? 2 and >r
     %offset is? 4 and nip r> or r> or
     []dim'd @ 8 and or ;

| : (init$   >inittype 7 and 2 =
     dup []init'd !  ?1more ;


\ *** Block No. 84, Hexblock 54

\   parser: initializer        12mar91pz

| : init[] ( type -- values )
     >inittype 6 and 2 =
     dup []init'd !  ?1more
     BEGIN constant-expression '1more
     ascii } #char# comes? not WHILE
     ascii , #char# expect
     ascii } #char# comes?
        IF 0  '1more  true
        ELSE false THEN
     UNTIL ;

| do$: init$ ( type -- values )
        (init$ '1more noop ;

| : initializer ( type -- values )
     ascii { #char# comes?
        IF init[] exit THEN
     #string# comes-a?
        IF drop init$ exit THEN
     >inittype 14 and 14 xor ?1more
     constant-expression '1more ;



\ *** Block No. 85, Hexblock 55

\   parser: declare-fcnt/data  14mar91pz

| : compare-types ( type1 type2 -- )
     xor %decl.mask and
     *!=type* ?error ;

| : declare ( type -- )
     id-buf findglobal ?dup
        IF >type @ compare-types
        ELSE drop *undef* error THEN ;

| : extern-op?
     ( type -- type' flag )
     <*=> #oper# comes?
        IF function?
           IF %stdfctn set
           ELSE *syntax* error THEN
        true
        ELSE </=> #oper# comes? THEN ;

| : define-extern ( type -- )
     %extern isn't? *???* ?error
     function? IF unnestlocal THEN
     constant-expression swap
     id-buf putglobal  2! ;

\ *** Block No. 86, Hexblock 56

\   parser: define-data        14mar91pz

| : dim-array ( type -- type' )
     []dim'd @ 0=
        IF []init'd @
           IF #inits @ #/obj !
           ELSE %reference set THEN
        THEN ;

| : size/# ( type -- type n )
     %pointer %function + isn't? >r
     array? >r is-char? r> r> or and
     2+ ;













\ *** Block No. 87, Hexblock 57

\   parser: define-data        11sep94pz

| defer 'stat,

| : create-static
    ( [values] type -- obj )
     size/# 1-
        IF ['] stat, ELSE ['] cstat,
        THEN IS 'stat,
     >r #inits @  #/obj @
     u> IF *initer* error
        #inits @  #/obj @  dup #inits !
        DO  drop  LOOP THEN
     #/obj @ #inits @
        ?DO 0 'stat, LOOP
     #inits @ 0
        ?DO   'stat, LOOP
     staticadr> r> ;








\ *** Block No. 88, Hexblock 58

\   parser: define-data        11sep94pz

| : create-dyn ( [value] type -- obj )
     size/# #/obj @ *  dyn-allot swap
     #inits @
        IF size/# .size  rot .lda#.s
        over .sta.s(base),# THEN ;



















\ *** Block No. 89, Hexblock 59

\   parser: define-data        11sep94pz

| defer 'putsymbol

| : define-data ( type -- )
     extern @
        IF declare exit THEN
     #inits off  []init'd off
     <=> #oper# comes?
        IF dup >r initializer r> THEN
     array?
        IF dim-array THEN
     %offset is?
        IF create-dyn
        ELSE create-static THEN
     id-buf 'putsymbol 2! ;










\ *** Block No. 90, Hexblock 5a

\   parser: define function    25apr94pz

~ variable protos2resolve
~ variable protos2patch

| : prototype ( type -- )
     unnestlocal
     id-buf findglobal ?dup
        IF >type @ compare-types
        ELSE %proto set  .label swap
        id-buf putglobal  dup >r  2!
        heap> ?dup
           IF dup 2+  r> over !
                  2+  .jmp-ahead swap !
           protos2resolve hook-into
           ELSE rdrop THEN
        THEN ;

~ : init-patches
     protos2resolve off
     protos2patch   off ;

     init: init-patches



\ *** Block No. 91, Hexblock 5b

\   parser: define function    25apr94pz

| : sort-in  ( addr2patch -- list )
     >r  protos2patch BEGIN
        dup @ 0= IF rdrop exit THEN
        dup @ 4 + @ r@ u<
                 IF rdrop exit THEN
        @ REPEAT ;

| : adjust-prototype
    ( obj desc type -- obj desc )
     2 pick compare-types   >r
     protos2resolve BEGIN dup
        @  dup 0= *compiler* ?fatal
        2+ @ r@ - WHILE  @ REPEAT
     hook-out  2 pick over 2+ !
     dup 4 + @  sort-in  hook-into ;

| : find/putglobal ( obj -- obj desc )
     id-buf findglobal ?dup
        IF dup >type @ %proto is?
           IF adjust-prototype exit
           ELSE 2drop THEN THEN
     id-buf putglobal ;


\ *** Block No. 92, Hexblock 5c

\   parser: define-function    14mar91pz

| : parameter' ( type -- )
     function? dup >r
        IF unnestlocal THEN
     array? r> or
        IF *param* error
        ELSE id-buf findparam
        ?dup 0= IF *undef* error drop
                ELSE >type ! THEN
        THEN ;

| : declare-parameters ( -- )
     ['] parameter' IS 'declarator
     BEGIN %local
     register-or-type? WHILE
     declarator-list';' REPEAT drop ;









\ *** Block No. 93, Hexblock 5d

\   parser: define function    14mar91pz

| : define-function ( type -- )
     #char# comes-a?
        IF backword
        dup ascii ; = swap ascii , = or
           IF prototype exit THEN THEN
     1st?
        IF .label swap
        find/putglobal 2!
         declare-parameters
          ascii { #char# expect
          compound
         unnestlocal
        .rts  flushcode
        function defined
        ELSE drop *syntax* error THEN ;









\ *** Block No. 94, Hexblock 5e

\   parser: type-specifiers    11sep94pz

| : global  ( -- )
     ['] putglobal IS 'putsymbol ;

| : local  ( -- )
     ['] putlocal IS 'putsymbol ;


| : declaration' ( type -- )
     function?
        IF unnestlocal declare
        ELSE local define-data THEN ;

| : definition' ( type -- )
     extern-op?
        IF define-extern exit THEN
     function?
        IF define-function
        ELSE global define-data THEN ;






\ *** Block No. 95, Hexblock 5f

\   parser: declaration        14mar91pz

| : declaration? ( -- flag )
     ['] declaration' IS 'declarator
     %local class-or-type?
        IF declarator-list';' true
        ELSE drop false THEN ;

| : definition? ( -- flag )
     ['] definition' IS 'declarator
     %global range-or-type?
        IF declarator-list';' true
        ELSE #eof# comes?
           IF drop false
           ELSE mark >r
           declarator-list';'
           r> advanced? THEN THEN ;









\ *** Block No. 96, Hexblock 60

\ parser: compound, program    09may94pz

  make compound ( -- )
     nestlocal
     BEGIN declaration? not UNTIL
     BEGIN statement? not UNTIL
     ascii } #char# expect
     unnestlocal ;

~ variable main()-adr

~ : compile-program ( -- )
     BEGIN definition? not UNTIL
     " main" findglobal ?dup 0=
        IF main()-adr off exit THEN
     2@ function?
        IF drop main()-adr ! exit THEN
     *bad-main* fatal ;








\ *** Block No. 97, Hexblock 61

\ parser:                      14mar91pz

























\ *** Block No. 98, Hexblock 62

                               18apr94pz

























\ *** Block No. 99, Hexblock 63

                               18apr94pz

























\ *** Block No. 100, Hexblock 64

\ invoke :  loadscreen         21sep94pz

  .( module invoke )

   1 3 +thru

   cr



















\ *** Block No. 101, Hexblock 65

\   invoke :  pass1            11sep94pz

~ : pass1 ( -- )
     open-outfiles
     ." source file: "
     source-name count type cr
     source-name open-input
     compile-program
     end-of-code close-outfiles ;

| : ?usage  ( flag -- )
     IF ." usage: cc file.c" cr
     rdrop THEN ;













\ *** Block No. 102, Hexblock 66

\   invoke :  start compiler   11sep94pz

| : wait-scratch  ( -- )
     dev 15 busin BEGIN bus@ drop
     i/o-status? UNTIL busoff ;

| : s!  count bustype ;
| : ,!  ascii , bus! ;

| : scratch-exe  ( -- )
     dev 15 busout " s0:" s!
     exe-name s!        ,!
     exe-name s! code.suffix s! ,!
     exe-name s! init.suffix s! ,!
     exe-name s! decl.suffix s!
     busoff
     wait-scratch ;









\ *** Block No. 103, Hexblock 67

\   invoke :  start compiler   13sep94pz

forth definitions

  : cc  ( -- )
     clearstack  init
     bl word   dup c@ 0= ?usage
     dup exe-name strcpy
         source-name strcpy
     exe-name count 2-
     dup exe-name c!  + @
    [ ascii . ascii c 256 * + ] literal
     -  ?usage
     scratch-exe
     cr cr ." pass 1:" cr
     pass1  cr
     any-errors? @
        IF ." error(s) occured" cr
        close-files scratchfiles exit
        THEN
     ." pass 2:" cr
     pass2  cr
     ." compilation done" cr
     scratchfiles ;


\ *** Block No. 104, Hexblock 68

\                              19apr94pz

























\ *** Block No. 105, Hexblock 69

                               18apr94pz

























\ *** Block No. 106, Hexblock 6a

                               18apr94pz

























\ *** Block No. 107, Hexblock 6b

                               18apr94pz

























\ *** Block No. 108, Hexblock 6c

\ pass2 :  loadscreen          21sep94pz

  .( module pass2 )

  1 11 +thru

  cr



















\ *** Block No. 109, Hexblock 6d

\   pass2 :                    11sep94pz

| variable #toread
| variable #inbuf
| variable p2in>
| ' code[ ALIAS p2in[
| ' ]code ALIAS ]p2in


| : p2readcode  ( -- )
     #toread @ 0=     *compiler* ?fatal
     code-file feof? *obj-short* ?fatal
     code-file fsetin   p2in[ p2in> !
     p2in[  ]p2in over - #toread @ umin
     fgets  dup #inbuf !
         negate #toread +!   funset ;

| : p2code@ ( -- 8b )
     #inbuf @ 0= IF p2readcode THEN
     -1 #inbuf +!
     p2in> @ c@  1 p2in> +! ;





\ *** Block No. 110, Hexblock 6e

\   pass2 :                    13sep94pz

| variable p2out>
| ' static[ ALIAS p2out[
| ' ]static ALIAS ]p2out


| : p2flush  ( -- )
     exe-file fsetout
     p2out[ p2out> @ over - fputs
     funset
     p2out[ p2out> ! ;

| : p2code!  ( 8b -- )
     p2out> @  under  c!
     1+ dup p2out> !
     ]p2out = IF p2flush THEN ;

~ : init-p2i/o  ( -- )
     p2out[  p2out> ! ;

    init: init-p2i/o




\ *** Block No. 111, Hexblock 6f

\   pass2 :                    13sep94pz

| : p2copy  ( last.adr+1 first.adr -- )
     ?DO p2code@ p2code! LOOP ;

| : p2wcode!  ( 16b -- )
     >lo/hi swap p2code! p2code! ;

| : p2wcode@drop  ( -- )
     p2code@ p2code@ 2drop ;

| : p2openfile
    ( len mode type name handle -- )
     ." linking " over count type cr
     fopen  2+ #toread !  #inbuf off
     p2readcode ;

| : p2closefile  ( handle -- )
     dup fclose
     feof? 0= *obj-long* ?fatal
     #toread @ #inbuf @ or
     *compiler* ?fatal ;




\ *** Block No. 112, Hexblock 70

\   pass2 :                    21sep94pz

| : link-runtimemodule  ( -- )
     ascii w ascii p exe-name
     exe-file fopen
     code.first @ lib.first @ -
     ascii r ascii p lib.codename
     code-file p2openfile
     >runtime @  lib.first @
     2- p2copy  \ copy load adress, too
     8 0 DO p2code@ drop LOOP
     main()-adr @    p2wcode!
     code.last @     p2wcode!
     statics.first @ p2wcode!
     statics.last @  p2wcode!
     code.first @ >runtime @ 8 + p2copy
     p2flush exe-file fclose
     code-file p2closefile ;








\ *** Block No. 113, Hexblock 71

\   pass2 :                    21sep94pz

| variable p2pc

| : link-code  ( -- )
     ascii a ascii p exe-name
     exe-file fopen
     code.last @ code.first @ -
     ascii r ascii p code-name
     code-file p2openfile
     p2wcode@drop \ drop load address
     code.first @ p2pc !
     BEGIN protos2patch hook-out ?dup
     WHILE dup 4 + @  ( list patchadr )
     dup  p2pc @  p2copy ( dito )
     2+ p2pc !  p2wcode@drop  ( list )
     2+ @ >lo/hi swap p2code! p2code!
     REPEAT
     code.last @  p2pc @ p2copy
     p2flush exe-file fclose
     code-file p2closefile ;





\ *** Block No. 114, Hexblock 72

\   pass2 :                    14jan96pz

| : (link-statics  ( n filename -- )
     over 0=
        IF ." no need to link "
        count type cr  drop exit THEN
     ascii a ascii p exe-name
                      exe-file fopen
     >r dup ascii r ascii p r>
               code-file  p2openfile
     p2wcode@drop  \ drop load address
     0 p2copy
     p2flush exe-file fclose
     code-file p2closefile ;

| : link-statics  ( -- )
     statics.libfirst @ statics.first @
     - static-name (link-statics
     statics.last @ statics.libfirst @
     - lib.initname (link-statics ;






\ *** Block No. 115, Hexblock 73

\   pass2 :                    21sep94pz

| : (link-lib ( n in-name w/a -- )
     dup >r
     ascii p exe-name exe-file fopen
     >r dup ascii r ascii p r>
                 code-file p2openfile
     r> ascii w =
        IF 2+ \ copy load adress
        ELSE p2wcode@drop THEN
     0 p2copy
     p2flush exe-file fclose
     code-file p2closefile ;

| : link-libstatics  ( -- )
   statics.last @ statics.libfirst  @ -
   lib.initname  ascii w (link-lib
   statics.libfirst @ statics.first @ -
   static-name   ascii a (link-lib ;







\ *** Block No. 116, Hexblock 74

\   pass2 :                    07may95pz

| : hex!  ( n -- )
     "  0x" count fputs
     base push hex 0 <# #s #> fputs ;

| : cr!  ( -- )  $0d fputc ;

| : str! ( string -- ) count fputs ;

| : write-libheader ( -- )
     cr!
     " #pragma cc64" str!
     >base         @ hex!
     >zp           @ hex!
     lib.first     @ hex!
     >runtime      @ hex!
     code.last     @ hex!
     statics.first @ hex!
     statics.last  @ hex!  bl fputc
     exe-name count 2 - fputs
     cr! cr! ;




\ *** Block No. 117, Hexblock 75

\   pass2 :                    11sep94pz

| : (write-decl ( name val type -- )
     %function %reference %pointer + +
     isn't? IF 2drop drop exit THEN
     " extern " str!
     is-char? IF   " char "
              ELSE " int " THEN str!
     %function %reference + isn't? >r
     %pointer is? r> and
        IF drop swap str! " [] /=" str!
        hex! exit THEN
     %pointer is? IF ascii * fputc THEN
     %function is?
        IF %reference isn't?
           IF rot str! ELSE " (*" str!
           rot str! ascii ) fputc THEN
        " ()" str! ELSE rot str! THEN
     %stdfctn is? IF "  *=" ELSE "  /="
     THEN str!  drop hex!
     "  ;" str!  cr! ;





\ *** Block No. 118, Hexblock 76

\   pass2 :                    11sep94pz

| : write-declarations  ( -- )
     ." creating " exe-name count
     type cr    ascii w ascii s
     exe-name exe-file fopen
     exe-file fsetout
     write-libheader
     ]hash hash[
     DO I @ ?dup
        IF dup count + 2@
        (write-decl THEN
     2 +LOOP
     funset  exe-file fclose ;

| : link-lib  ( -- )
     code.suffix  exe-name strcat
     link-runtimemodule  link-code
     exe-name cut-suffix
     init.suffix exe-name strcat
     link-libstatics
     exe-name cut-suffix
     decl.suffix exe-name strcat
     write-declarations ;


\ *** Block No. 119, Hexblock 77

\   pass2 :                    11sep94pz

| : link-exe  ( -- )
     link-runtimemodule  link-code
     link-statics ;

~ : pass2  ( -- )
     main()-adr @
        IF link-exe
        ELSE link-lib THEN ;
















\ *** Block No. 120, Hexblock 78

\   pass2:                     11sep94pz

























\ *** Block No. 121, Hexblock 79

\   pass2:                     04sep94pz

























\ *** Block No. 122, Hexblock 7a

                               24aug94pz

























\ *** Block No. 123, Hexblock 7b

                               24aug94pz

























\ *** Block No. 124, Hexblock 7c

                               24aug94pz

























\ *** Block No. 125, Hexblock 7d

                               24aug94pz

























\ *** Block No. 126, Hexblock 7e

\ shell loadscreen             21sep94pz

  .( module shell )

  1 4 +thru

  cr



















\ *** Block No. 127, Hexblock 7f

\   shell:                     21sep94pz

Code bye   $37 # lda  $1 sta
           $a000 ) jmp  end-code

' savesystem        alias saveall
' .mem              alias mem
' himem!            alias set-himem
' #links!           alias set-heap
' #globals!         alias set-hash
' symtabsize!       alias set-symtab
' codesize!         alias set-code
' relocate          alias set-stacks

: auxdev ( n -- )             aux# c! ;
: device ( n -- ) dup dev# c! aux# c! ;
: device?  ( -- )
 ." actual device number is " dev . cr
 ." auxiliar dev. number is " aux . ;
\\
: delay  ( n -- )  fdelay ! ;
: delay? ( -- )
   ." delay after fopen/fclose is" cr
   fdelay @ u. ." /60 seconds." cr ;


\ *** Block No. 128, Hexblock 80

\   shell:                     09sep94pz

: dir  ( -- )
   dev 0 busopen  ascii $ bus! busoff
   dev 0 busin bus@ bus@ 2drop
   BEGIN cr bus@ bus@ 2drop
   i/o-status? 0= WHILE
   bus@ bus@ lo/hi> u.
   BEGIN bus@ ?dup WHILE con! REPEAT
   REPEAT busoff  dev 0 busclose ;

: dos  ( -- )
   bl word count ?dup
      IF dev 15 busout bustype
      busoff cr ELSE drop THEN
   dev 15 busin
   BEGIN bus@ con! i/o-status? UNTIL
   busoff ;

: cat   ( -- ) cr
   dev 2 busopen  bl word count bustype
   busoff  dev 2 busin  BEGIN bus@ con!
   i/o-status? UNTIL busoff
   dev 2 busclose ;


\ *** Block No. 129, Hexblock 81

\   shell: cold' logo          01mar20pz

| Code charset  here 6 + jsr xyNext jmp
                 $cbfa ) jmp end-code

| : init-shell  ( -- )
     only shell
     $cbfc 2@  $65021103. d=
        IF charset THEN ;

' init-shell IS 'cold


| : .logo  ( -- )
     ."     running" cr
     ." cc64 C compiler V0.5" cr
     ." 2020 by Philip Zembrod" cr
     $cbfc 2@  $65021103. d= not ?exit
     ." C charset in use" cr ;

' .logo IS 'restart





\ *** Block No. 130, Hexblock 82

\   shell                      20sep94pz

: help  ." available commands:" cr
        words ;

' cc                alias cc




















\ *** Block No. 131, Hexblock 83



























\ *** Block No. 132, Hexblock 84



























\ *** Block No. 133, Hexblock 85



























\ *** Block No. 134, Hexblock 86



























\ *** Block No. 135, Hexblock 87



























\ *** Block No. 136, Hexblock 88



























\ *** Block No. 137, Hexblock 89



























\ *** Block No. 138, Hexblock 8a



























\ *** Block No. 139, Hexblock 8b



























\ *** Block No. 140, Hexblock 8c

\ parser: declaration basics   21feb91pz

| variable obj-type
| variable obj-type'
| variable obj-val

| variable #/obj
| variable #inits
| variable []init'd
| variable []dim'd

| : !set ( mask -- )
     obj-type @ swap set obj-type ! ;

| : !clr ( mask -- )
     obj-type @ swap clr obj-type ! ;

| : @is? ( mask -- flag )
     obj-type @ swap is? nip ;

| : @isn't? ( mask -- flag )
     obj-type @ swap isn't? nip ;




\ *** Block No. 141, Hexblock 8d

\   parser: declaration basics 26feb91pz

| : !set-int ( -- )
     obj-type @ set-int obj-type ! ;

| : !set-char ( -- )
     obj-type @ set-char obj-type ! ;

| : @is-int? ( -- flag )
     obj-type @ is-int? nip ;

| : @is-char? ( -- flag )
     obj-type @ is-char? nip ;

| : val/type>tab ( desc -- )
     obj-val @  obj-type @  rot 2! ;

| : array?
     %reference %function + @isn't?
     %pointer @is? and ;

| : function?
     %function @is? %reference @isn't?
     and ;


\ *** Block No. 142, Hexblock 8e

\   parser: type-specifiers    26feb91pz

| : type-name? ( -- flag )
     <char> #keyword# comes?
        IF !set-char true
        ELSE <int> #keyword# comes?
           IF !set-int true
           ELSE false THEN THEN ;

| : [type-name] ( -- )
     type-name? drop ;















\ *** Block No. 143, Hexblock 8f

\   parser: type-specifiers    21jan91pz

| : register? ( -- flag )
     <register> #keyword# comes? dup
        IF ( %register !set ) THEN ;

| : [register]  register? drop ;

| : register-or-type? ( -- flag )
     register?
        IF [type-name] true
        ELSE type-name?
           IF [register] true
           ELSE false THEN THEN ;












\ *** Block No. 144, Hexblock 90

\   parser: type-specifiers    21jan91pz

| : extern? ( -- flag )
     <extern> #keyword# comes? dup
        IF %extern !set THEN ;

| : static? ( -- flag )
     <static> #keyword# comes? dup
        IF %extern !clr THEN ;

| : [static]  static? drop ;

| : class? ( -- flag )
     <auto> #keyword# comes?
        IF true exit THEN
     <static> #keyword# comes?
        IF %offset !clr true exit THEN
     <register> #keyword# comes?
        IF ( %register !set ) true
        ELSE false THEN ;

| : [class]  class? drop ;




\ *** Block No. 145, Hexblock 91

\   parser: declarator         23feb91pz

| create id-buf /id 1+ allot

| : handle-id  ( -- )
     id-buf off  #id# comes-a?
        IF id-buf over c@ 1+ cmove
        ELSE *expected* error
        ." identifier" THEN ;


| : parameter-list ( -- )
     ascii ) #char# comes? not
        IF BEGIN #id# comes-a?
           IF putlocal
           2 dyn-allot %local  rot 2!
           ELSE *expected* error
           ." identifier" THEN
        ascii , #char# comes? not UNTIL
        ascii ) #char# expect THEN ;






\ *** Block No. 146, Hexblock 92

\   parser: declarator         23feb91pz

| : handle-function ( -- )
     function?  IF unnestlocal THEN
     %function @is?
        *double-func* ?error
     %function !set
     %pointer @is?
        IF []dim'd @ *???* ?error
        []dim'd off  1 #/obj !
        %pointer !clr  %reference !set
        ELSE %reference !clr THEN
     function?
        IF nestlocal
        function not active?
           IF tos-offs off
           parameter-list
           ELSE ascii ) #char# expect
           THEN
        THEN ;






\ *** Block No. 147, Hexblock 93

\   parser: declarator         23feb91pz

|  variable ptr
| : mark-ptr ( -- )   ptr @  ptr on
     *double-ptr* ?error ;

| : set-pointer ( -- )
     %pointer @is?  *double-ptr* ?error
     %pointer !set ;

| : handle-array ( -- )
     set-pointer  %function @is?
        IF ascii ] #char# expect
        ELSE %reference !clr
        ascii ] #char# comes? not
           IF constant-expression
           #/obj !  []dim'd on
           ascii ] #char# expect THEN
        THEN ;







\ *** Block No. 148, Hexblock 94

\   parser: declarator         23feb91pz

| : (declarator ( -- )
     obj-type' @ obj-type !
     1 #/obj !  []dim'd off
     ptr off BEGIN  <*> #oper# comes?
     WHILE mark-ptr REPEAT
     ascii ( #char# comes?
        IF ptr @  recursive (declarator
           ptr !  ascii ) #char# expect
        ELSE handle-id THEN
     BEGIN mark
     ascii [ #char# comes?
        IF handle-array THEN
     ascii ( #char# comes?
        IF handle-function THEN
     advanced? not UNTIL
     ptr @ IF set-pointer THEN ;

| defer 'declarator ( -- )

| : declarator ( -- )
     (declarator 'declarator ;



\ *** Block No. 149, Hexblock 95

\   parser: declarator         23feb91pz

| variable (1st
| : 1st  (1st on ;
| : 2nd  (1st off ;
| : 1st? (1st @ ;

\ variable function :does> 0 ;
\ : defined   swap ! ;
\ : defined?  swap @ = ;

\   function [ not ] defined
\   function [ not ] defined?

| : declarator-list ( -- )
     obj-type @ obj-type' !
     function not defined
     1st declarator
     function defined? ?exit
     BEGIN ascii , #char# comes? WHILE
     2nd declarator REPEAT ;





\ *** Block No. 150, Hexblock 96

\   parser: initializer        21feb91pz

| : 1more ( n -- n )
     ?savestack  1 #inits +! ;

| : nomore ( n -- )  drop ;

| defer '1more



| : []legal? ( -- )
     array? %offset @isn't? and
        IF []init'd on   ['] 1more
        ELSE *initer* error
        ['] nomore THEN
     IS '1more ;

| : ""legal? ( -- )
     []legal?
     @is-int? *!=type* ?error ;





\ *** Block No. 151, Hexblock 97

\   parser: initializer        21feb91pz

| : []init ( -- values )
     []legal?
     BEGIN constant-expression '1more
     ascii } #char# comes? not WHILE
     ascii , #char# expect
     ascii } #char# comes?
        IF 0  '1more  true
        ELSE false THEN
     UNTIL ;

| do$: ""init  ""legal? '1more noop ;

| : initializer ( -- values )
     ascii { #char# comes?
        IF []init exit THEN
     #string# comes-a?
        IF drop ""init exit THEN
     constant-expression 1more ;






\ *** Block No. 152, Hexblock 98

\   parser: declare-fcnt/data  26feb91pz

| : compare-types ( obj -- )
     nip  obj-type @  xor
     %expr.mask and
     *!=type* ?error ;

| : declare-data ( -- )
     id-buf findglobal ?dup
        IF 2@ compare-types
        ELSE *undef* error THEN ;

| : declare-function ( -- )
     unnestlocal
     declare-data ;











\ *** Block No. 153, Hexblock 99

\   parser: define-data        21feb91pz

| : dim-array ( -- )
     []dim'd @ 0=
        IF []init'd @
           IF #inits @ #/obj !
           []dim'd on THEN THEN ;

| : b/obj ( -- b/obj )
     2 @is-char?
        IF %pointer %function + @isn't?
           IF 1- exit THEN
        array? IF 1- THEN
        THEN ;












\ *** Block No. 154, Hexblock 9a

\   parser: define-data        26feb91pz

| : init-dyn ( [value] b/obj -- )
     .size  #inits @
        IF .lda#
        $base obj-val @ .sta(),# THEN ;


| defer 'stat,

| : init-static ( [values] b/obj -- )
     1- IF ['] stat, ELSE cstat, THEN
         IS 'stat,
     #inits @ #/obj @ 2dup
     u> IF *initer* error
        DO ?loadstack drop LOOP
        #/obj @ #inits !
        ELSE 2drop THEN
     #/obj @ #inits @
        ?DO 0 'stat, LOOP
     #inits @ 0
        ?DO ?loadstack 'stat, LOOP ;




\ *** Block No. 155, Hexblock 9b

\   parser: define-data        21feb91pz

| : define-data ( -- )
     #inits off  []init'd off
     +savestack
     <=> #oper# comes?
        IF initializer THEN
     array?
        IF dim-array  []dim'd @
           IF %reference !clr THEN
        THEN
     b/obj %offset @is?
        IF dup #/obj * dyn-allot
        obj-val !
        init-dyn
        ELSE init-static
        staticadr> obj-val !
        THEN
     -savestack ;







\ *** Block No. 156, Hexblock 9c

\   parser: define-data        16jan91pz

| : define-global ( -- )
     </=> #oper# comes?
       IF constant-expression obj-val !
       ELSE define-data THEN
     id-buf putglobal val/type>tab ;

| : define-local ( -- )
     define-data
     id-buf putlocal val/type>tab ;















\ *** Block No. 157, Hexblock 9d

\   parser: define function    26feb91pz

| : ext-fnct ( -- )
     unnestlocal
     constant-expression  obj-val !
     id-buf putglobal  val/type>tab ;

| : prototype ( -- )
     unnestlocal
     id-buf findglobal ?dup
        IF 2@ compare-types
        ELSE %proto !set  pc obj-val !
        id-buf putglobal
        freelist hook-out ?dup
           IF dup patches hook-into
           2+ 2dup !
           2+ .jmp-ahead swap ! THEN
        val/type>tab THEN ;








\ *** Block No. 158, Hexblock 9e

\   parser: define function    26feb91pz

| : adjust-prototype
    ( desc type -- desc )
     %proto clr obj-type @ -
        *!=type* ?error
     patches BEGIN @ dup WHILE
     2dup 2+ @ = UNTIL
     ?dup IF 2+ pc swap ! THEN ;

| : find/putglobal ( -- desc )
     id-buf findglobal ?dup
        IF dup >type @ %proto is?
           IF adjust-prototype exit
           ELSE 2drop THEN THEN
     id-buf putglobal ;










\ *** Block No. 159, Hexblock 9f

\   parser: define-function    26feb91pz

| create dummy  4 allot

| : parameter' ( -- )
     function? dup
        IF unnestlocal THEN
     array? or
        IF *param* error
        ELSE id-buf findparam
        ?dup 0= IF *undef* error
                dummy THEN
        obj-type @ swap >type ! THEN ;

| : declare-parameters ( -- )
     BEGIN obj-type off  %offset !set
     register-or-type? WHILE
     ['] parameter' IS 'declarator
     declarator-list
     expect';' REPEAT ;






\ *** Block No. 160, Hexblock a0

\   parser: define function    26feb91pz

| : define-function ( -- )
     ascii ; #char# comes?
        IF prototype backword exit THEN
     ascii , #char# comes?
        IF prototype backword exit THEN
     </=> #oper# comes?
        IF ext-fnct           exit THEN
     <*=> #oper# comes?
        IF %stdfctn !set ext-fnct
                              exit THEN
     1st?
        IF pc obj-val ! function active
        find/putglobal  val/type>tab
         declare-parameters
          ascii { #char# expect
          compound
         unnestlocal
        .rts
        function not active
        function defined
        ELSE *syntax* error THEN ;



\ *** Block No. 161, Hexblock a1

\   parser:                    23feb91pz

| : def.local' ( -- )
     function?
        IF declare-function
        ELSE define-local THEN ;

| : ext.local' ( -- )
     function?
        IF declare-function
        ELSE declare-data THEN ;

| : def.global' ( -- )
     function?
        IF define-function
        ELSE define-global THEN ;

| : ext.global' ( -- )
     function?
        IF define-function
        ELSE declare-data THEN ;





\ *** Block No. 162, Hexblock a2

\   parser: declaration        21feb91pz

| : def.local ( -- )
     ['] def.local' IS 'declarator
     declarator-list
     expect';' ;

| : ext.local ( -- )
     ['] ext.local' IS 'declarator
     declarator-list
     expect';' ;

| : def.global ( -- )
     ['] def.global' IS 'declarator
     declarator-list
     function not defined?
        IF expect';' THEN ;

| : ext.global ( -- )
     ['] ext.global' IS 'declarator
     declarator-list
     function not defined?
        IF expect';' THEN ;



\ *** Block No. 163, Hexblock a3

\   parser: type-specifiers    22feb91pz

| : definition ( -- flag )  false
     %global obj-type ! extern?
        IF [type-name]  ext.global
     ELSE static?
        IF [type-name]  def.global
     ELSE type-name? not ?exit
     extern?  IF        ext.global
     ELSE [static]      def.global
     THEN THEN THEN not ;

| : declaration ( -- flag ) false
     %local obj-type !  extern?
        IF [type-name]  ext.local
     ELSE class?
        IF [type-name]  def.local
     ELSE type-name? not ?exit
     extern?  IF        ext.local
     ELSE [class]       def.local
     THEN THEN THEN not ;





\ *** Block No. 164, Hexblock a4

\ parser: compound, program    23feb91pz

  make compound ( -- )
     nestlocal
     BEGIN declaration not UNTIL
     BEGIN statement not UNTIL
     ascii } #char# expect
     unnestlocal ;

~ : program ( -- )
     function not active
     BEGIN definition not UNTIL ;














\ *** Block No. 165, Hexblock a5



























\ *** Block No. 166, Hexblock a6



























\ *** Block No. 167, Hexblock a7



























\ *** Block No. 168, Hexblock a8



























\ *** Block No. 169, Hexblock a9


























