\ *** Block No. 12, Hexblock c

\ codegen loadscreen           21sep94pz

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
     \ flag = true <=> alle gesetzten
     \ mask-bits in n gesetzt bzw.
     \ geloescht


\ *** Block No. 15, Hexblock f

\   codegen: objects           11mar91pz

|| : size? ( obj -- obj size )
     %pointer %function + isn't? >r
     is-char? r> and 2+ ;

\ size? und .size machen nur bei
\ %reference-objekten sinn !


~ 0 set-int  constant %default
  \ default data type, e.g type of
  \ a multipication's result

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

|| defer 'value      ( obj1 -- obj2 )

| : value ( obj1 -- obj2 )
   %reference is?
      IF 'value  %reference clr
      %function %pointer + isn't?
         IF set-int THEN THEN ;

|| : reference ( obj1 -- obj2 )
   %reference is?
      IF %reference clr
      ELSE *noref* error THEN ;


\ *** Block No. 17, Hexblock 11

\ codegen: constant, doit      18apr94pz

|| variable a-used

|| : require-accu
     a-used @ IF .pha' THEN
     a-used on ;

~ : release-accu
     a-used off ;

| : non-constant ( obj1 -- obj2 )
     %constant is?  IF %constant clr
       require-accu  over .lda# THEN ;

   init: release-accu


|| variable vector

|| : doit ( n -- )
     vector @ + perform ;
  \ for unop, incop and do-binop, who
  \ all use vectors


\ *** Block No. 18, Hexblock 12

\ codegen: combined type tests 01mar91pz

|| : pointer? ( type -- type flag )
     %pointer is? >r %function isn't?
     r> and ;
  ( for do-add and do-sub )

|| : int-pointer? ( type -- type flag )
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

\ TODO: This could probably return a %const value; the address of the
\ string is, after all, essentially known at compile time.

| : do-stringatom ( adr -- obj )
     require-accu  .lda#
     [ %default %pointer set set-char ]
     0  literal ;


|| : do-lda(a) ( obj1 -- obj2 )
     size? .size
     %constant is?
        IF   require-accu
        over .lda.s  %constant clr
        ELSE .sta-zp .lda.s(zp) THEN ;


\ *** Block No. 20, Hexblock 14

\   codegen: atom              27may91pz

|| : do-lda(base),# ( obj1 -- obj2 )
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


|| : unop ( cfa2 cfa0 -- )
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

|| : incop ( cfa6 cfa4 cfa2 cfa0 -- )
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

\ the complications are due to the
\ different adressing modes and to
\ the scaling of pointers.


\ *** Block No. 27, Hexblock 1b

\   codegen: unary             27may91pz

|| : ++x0 over dup .incr.s   .lda.s ;
|| : ++x2 over dup .2incr.s  .lda.s ;
|| : ++x4 .add#  .sta.s(zp) ;
|| : ++x6 .add#  .sta.s(base),# ;

|| : --x0 over dup .decr.s   .lda.s ;
|| : --x2 over dup .2decr.s  .lda.s ;
|| : --x4 .sub#  .sta.s(zp) ;
|| : --x6 .sub#  .sta.s(base),# ;

|| : x++0 over dup .lda.s  .incr.s ;
|| : x++2 over dup .lda.s  .2incr.s ;
|| : x++4 .pha .add#  .sta.s(zp) .pla ;
|| : x++6 .pha .add#  .sta.s(base),#
                                .pla ;

|| : x--0 over dup .lda.s  .decr.s ;
|| : x--2 over dup .lda.s  .2decr.s ;
|| : x--4 .pha .sub#  .sta.s(zp) .pla ;
|| : x--6 .pha .sub#  .sta.s(base),#
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

|| variable typ

|| : setconst ( -- )
     typ @  %constant set  typ ! ;

    ' setconst ' swap ' noop ' drop
|| create const-vec    , , , ,

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

|| create add-vec
  ' + ' .add# ' .add# ' .add , , , ,

| : do-add ( obj1 obj2 -- obj3 )
     2swap pointer?
        IF dup %constant clr typ !
        is-int? >r  2swap r>
           IF do-shla THEN
        ELSE %default typ ! THEN
     add-vec do-binop ;

\ complications are due to pointer
\ scaling.


\ *** Block No. 31, Hexblock 1f

\   codegen: binary            11sep94pz

|| variable shra-flag
|| create sub-vec
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

\ complications are due to pointer
\ scaling.


\ *** Block No. 32, Hexblock 20

\   codegen: binary            12sep90pz

|| : binop ( cfa3 cfa2 cfa1 cfa0 -- )
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

|| : <=  swap > ;
|| : >=  swap < ;
|| : !=  = 0= ;

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

|| : << ( n1 n2 -- n3 )
     0 ?DO 2* LOOP ;
|| : >> ( n1 n2 -- n3 )
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

|| : is0? ( obj -- obj flag )
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
