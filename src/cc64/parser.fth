\ *** Block No. 48, Hexblock 30

\ parser loadscreen            21sep94pz

~ variable protos2patch

||on

: teststack  ( -- )
     here $80 + sp@ u> *stack* ?fatal
     up@ udp @ + $40 + rp@ u>
                      *rstack* ?fatal ;


\ *** Block No. 49, Hexblock 31

\ parser: tools                22feb91pz

: comes? ( tokenvalue token -- flag )
    thisword dnegate d+ or
    IF false ELSE accept true THEN ;

: comes-a? ( token -- tokenvalue true )
           ( token -- false )
    thisword rot = dup not
    IF nip THEN ;

: expect ( tokenvalue token -- )
    2dup comes?
       IF 2drop
       ELSE word. *expected* error
       THEN ;

: expect';'  ascii ; #char# expect ;
: expect':'  ascii : #char# expect ;
: expect'('  ascii ( #char# expect ;
: expect')'  ascii ) #char# expect ;
: expect']'  ascii ] #char# expect ;


\ : skipword ( -- )
\    *ignored* error nextword word. ;


\ *** Block No. 50, Hexblock 32

  cr .( submodule expression ) cr

\ parser: atom                 13sep94pz

: cp$[ ( -- jmp adr )
     .jmp-ahead  .label ;

: cp]$ ( jmp adr -- adr )
     swap .resolve-jmp ;

do$: compile$  ( -- adr )
        cp$[ .byte cp]$ ;

\ obj in stack comments represents a data value in an expression and
\ consists of two values: obj = val type
\ val will be the actual value in case the expression so far is already
\ known at compile time, or a placeholder in case the value is only
\ known at run time.
\ type represents the data type of the value, a bitmap made up of the
\ definitions %int, %pointer, %function etc. from the beginning of
\ codegen.fth.

: atom ( -- obj )
   #number# comes-a?
      IF accept do-numatom  exit THEN
   #id#     comes-a?
      IF accept do-idatom   exit THEN
   #string# comes-a?
      IF drop compile$
      do-stringatom  accept exit THEN
   ." a value" *expected* error
   \ consider skipword
   0 do-numatom ;


\ *** Block No. 51, Hexblock 33

\ parser: primary              15mar91pz

doer expression
doer assign

: primary[] ( obj1 -- obj2 )
   value
   expression value  do-add
   do-pointer
   expect']' ;


\ *** Block No. 52, Hexblock 34

\   parser: primary            26apr20pz

: std-arguments ( -- )
     assign put-std-argument
     BEGIN ascii , #char# comes? WHILE
     assign drop-std-argument REPEAT ;

: arguments  ( -- )
     BEGIN assign put-argument
     ascii , #char# comes? not UNTIL ;

: primary() ( obj1 -- obj2 )
     %stdfctn is?
        IF ascii ) #char# comes? not
           IF std-arguments
           expect')' THEN
        do-std-call
        ELSE prepare-call
        ascii ) #char# comes? not
           IF arguments
           expect')' THEN
        do-call THEN ;


\ *** Block No. 53, Hexblock 35

\   parser: primary            11sep94pz

: primary ( -- obj )
     teststack
     ascii ( #char# comes?
        IF expression
        expect')'
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

: comes-tab-token? ( tab token -- cfa true )
                   ( tab token -- false )
     comes-a?
        IF swap  dup 2+ swap @ bounds
        DO dup I @ =
          IF accept  drop  I 2+ @
          true UNLOOP exit THEN
        4 +LOOP
        THEN
     drop  false ;

create unary-tab1  7  4 * ,
  <->   ,  ' do-neg     ,
  <!>   ,  ' do-not     ,
  <inv> ,  ' do-inv     ,
  <*>   ,  ' do-pointer ,
  <and> ,  ' do-adress  ,
  <++>  ,  ' do-preinc  ,
  <-->  ,  ' do-predec  ,

create unary-tab2  2  4 * ,
  <++>  ,  ' do-postinc ,
  <-->  ,  ' do-postdec ,

: unary ( -- obj )  recursive
   unary-tab1 #oper# comes-tab-token?
     IF >r unary r> execute  exit THEN
   primary
   unary-tab2 #oper# comes-tab-token?
     IF execute  exit THEN ;


\ *** Block No. 55, Hexblock 37

\ parser: binary               06mar91pz

: binary  ( tab -- )
    create , dup 4 * ,  0
     DO swap , , LOOP
    does>   ( tab -- obj )
     dup @ execute
     BEGIN 2 pick 2+ #oper# comes-tab-token? WHILE >r
     value  2 pick @ execute value
     r> execute REPEAT
     2 roll drop ;


\ *** Block No. 56, Hexblock 38

\   parser: binary             08apr90pz

  <*>   ' do-mult
  </>   ' do-div
  <%>   ' do-mod
  3  ' unary   binary product

  <+>   ' do-add
  <->   ' do-sub
  2  ' product binary sum

  <<<>  ' do-shl
  <>>>  ' do-shr
  2  ' sum     binary shift

  <<>   ' do-lt
  <<=>  ' do-le
  <>>   ' do-gt
  <>=>  ' do-ge
  4  ' shift   binary comp

  <==>  ' do-eq
  <!=>  ' do-ne
  2  ' comp    binary equal


\ *** Block No. 57, Hexblock 39

\   parser: binary             09oct90pz

  <and> ' do-and
  1  ' equal   binary bit-and

  <xor> ' do-xor
  1  ' bit-and binary bit-xor

  <or>  ' do-or
  1  ' bit-xor binary bit-or

: l-and ( -- obj )
     bit-or
     BEGIN  <l-and> #oper# comes? WHILE
     do-l-and.1  bit-or
     do-l-and.2  REPEAT ;

: l-or ( -- obj )
     l-and
     BEGIN  <l-or> #oper# comes? WHILE
     do-l-or.1  l-and
     do-l-or.2  REPEAT ;


\ *** Block No. 58, Hexblock 3a

\   parser: binary             07apr90pz

: conditional ( -- obj )
     l-or
     ascii ? #char# comes?
        IF do-cond1
        recursive conditional
        do-cond2
        expect':'
        recursive conditional
        do-cond3 THEN ;


\ *** Block No. 59, Hexblock 3b

\ parser: assign               06mar91pz

create assign-oper  11  4 * ,
  <=>    ,    0       ,
  <*=>   ,  ' do-mult ,
  </=>   ,  ' do-div  ,
  <%=>   ,  ' do-mod  ,
  <+=>   ,  ' do-add  ,
  <-=>   ,  ' do-sub  ,
  <<<=>  ,  ' do-shl  ,
  <>>=>  ,  ' do-shr  ,
  <and=> ,  ' do-and  ,
  <xor=> ,  ' do-xor  ,
  <or=>  ,  ' do-or   ,


\ *** Block No. 60, Hexblock 3c

\   parser: assign             08apr90pz

  make assign ( -- obj )
     conditional
     assign-oper #oper# comes-tab-token?
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


: constant-expression ( -- val )
     assign value  %constant isn't?
     *noconst* ?error  drop ;

: expr-to-accu  ( -- )
     expression value non-constant
     2drop release-accu ;


\ *** Block No. 62, Hexblock 3e

\ parser: statement            12mar91pz

  .( submodule statement ) cr

doer compound
doer statement

: expression-stmt ( -- )
      expr-to-accu  expect';' ;

: return-stmt ( -- )
      ascii ; #char# comes? not
         IF expression-stmt THEN
      .rts ;


\ *** Block No. 63, Hexblock 3f

\   parser: statement          22feb91pz

: (expr-to-accu)  ( -- )
     expect'('  expr-to-accu  expect')' ;

: if-stmt  ( -- )
     (expr-to-accu)
     .jmz-ahead
     statement
     <else> #keyword# comes?
        IF .jmp-ahead swap .resolve-jmp
        statement THEN
     .resolve-jmp ;


\ *** Block No. 64, Hexblock 40

\   parser: statement          12mar91pz

: ?drop&exit ( n flag -- n / -- )
      IF drop rdrop THEN ;

: new  ( list -- )
     heap> ?dup 0= ?drop&exit
     dup 2+ off  swap hook-into ;

: resolve  ( list -- )
     BEGIN dup hook-out  dup >heap
     2+ @ ?dup WHILE
     .resolve-jmp REPEAT drop ;


\ *** Block No. 65, Hexblock 41

\   parser: statement          12mar91pz

variable breaks
variable conts

: another  ( list -- )
     dup @ 0= IF *ill-brk* error
              drop exit THEN
     heap> ?dup 0= ?drop&exit
     .jmp-ahead over 2+ !
     swap hook-into ;

: break-stmt ( -- )
     breaks another  expect';' ;

: continue-stmt ( -- )
     conts another  expect';' ;

: init-breaks  breaks off conts off ;
     init: init-breaks


\ *** Block No. 66, Hexblock 42

\   parser: statement          18apr94pz

variable switch-state ( 0/-1/def.adr)
variable cases

: init-switch   switch-state off
     cases off ;
    init: init-switch

: case-stmt ( -- )
     constant-expression
     expect':'
     switch-state @ 0=   IF drop
        *noswitch* error exit THEN
     heap> ?dup 0= ?drop&exit
     dup  cases hook-into
     2+ .label over !  2+ ! ;

: default-stmt ( -- )
     expect':'
     switch-state @ 1+
        IF *ill-default* error
        ELSE .label switch-state !
        THEN ;


\ *** Block No. 67, Hexblock 43

\   parser: statement          27may91pz

: cases-resolve ( -- )
     BEGIN cases hook-out  dup >heap
     2+ dup @ ?dup WHILE
     .word 2+ @ .word REPEAT
     drop  0 .word ;

: switch-stmt  ( -- )
     switch-state @ switch-state on
     breaks new  cases new
     (expr-to-accu)  .jmp-ahead
     statement
     .jmp-ahead  swap  .resolve-jmp
     .switch  cases-resolve
     switch-state @ not ?dup
        IF not .jmp THEN  \ default
     .resolve-jmp  breaks resolve
     switch-state ! ;

\ $switch tay:pla:ina:sta zp:tya:ldy#0
\  [[ pha:lda(zp):ne?[[ sta vec:winc zp
\   pla:cmp(zp):eq?[ jmp(vec) ]?
\   winc zp ]]? winc zp:jmp(zp)


\ *** Block No. 68, Hexblock 44

\   parser: statement          22feb91pz

: do-stmt  ( -- )
     breaks new  conts new
     .label  statement  conts resolve
     <while> #keyword# expect
     (expr-to-accu)  .jmn
     breaks resolve  expect';' ;

: while-stmt  ( -- )
     breaks new  conts new
     .label  (expr-to-accu)
     .jmz-ahead
     statement  conts resolve
     swap .jmp  .resolve-jmp
     breaks resolve ;


\ *** Block No. 69, Hexblock 45

\   parser: statement          22feb91pz

\ : 1st-expression  ( -- )
\    ascii ; #char# comes? not
\      IF expr-to-accu  expect';' THEN ;

: 2nd-expression? ( -- flag )
     ascii ; #char# comes? not dup
       IF expr-to-accu  expect';' THEN ;

: 1st-expression  ( -- )
     2nd-expression? drop ;

: 3rd-expression  ( -- )
     ascii ) #char# comes? not
        IF expr-to-accu
        expect')' THEN ;


\ *** Block No. 70, Hexblock 46

\   parser: statement          22feb91pz

: for-stmt ( -- )
     breaks new  conts new
     expect'('
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

create statement-tab  10  4 * ,
  <break>   ,  ' break-stmt    ,
  <cont>    ,  ' continue-stmt ,
  <if>      ,  ' if-stmt       ,
  <do>      ,  ' do-stmt       ,
  <while>   ,  ' while-stmt    ,
  <for>     ,  ' for-stmt      ,
  <case>    ,  ' case-stmt     ,
  <default> ,  ' default-stmt  ,
  <switch>  ,  ' switch-stmt   ,
  <return>  ,  ' return-stmt   ,

: statement? ( -- flag )  true
  statement-tab #keyword# comes-tab-token?
    IF execute  exit THEN
  #char# comes-a? IF
  ascii { case? IF accept compound   exit THEN
  ascii ; case? IF accept            exit THEN
  ascii } case? IF not               exit THEN
  drop THEN  drop
  mark expression-stmt advanced? ;


 make statement ( -- )
  teststack
  statement? not
     IF ." statement" *expected* error THEN ;


\ *** Block No. 73, Hexblock 49

\ parser: declaration basics   14mar91pz

  .( submodule definition ) cr

variable #/obj
variable []dim'd
variable #inits
variable []init'd

variable extern

: >type  ( desc -- desc.type )
          ; immediate

\ haengt von der wirkungsweise von
\ 2@ u. 2! ab, mit denen normalerweise
\ auf die symboltabelle zugegriffen
\ wird.


\ *** Block No. 74, Hexblock 4a

\   parser: declaration basics 14mar91pz

variable function :does> 0 ;

: defined   swap ! ;
: defined?  swap @ = ;

\   function [ not ] defined
\   function [ not ] defined?


\ *** Block No. 75, Hexblock 4b

\   parser: type-specifiers    14mar91pz

: type-name? ( type -- type' flag )
     <char> #keyword# comes?
        IF set-char true
        ELSE <int> #keyword# comes?
           IF set-int true
           ELSE false THEN THEN ;

: register? ( type -- type' flag )
     <register> #keyword# comes?
        IF ( %register set ) true
        ELSE false THEN ;

: extern? ( type -- type' flag )
     <extern> #keyword# comes?
        IF %extern set  %offset clr
           extern on  true
        ELSE false THEN ;


\ *** Block No. 76, Hexblock 4c

\   parser: type-specifiers    14mar91pz

: range? ( type -- type' flag )
     extern? ?dup ?exit
     <static> #keyword# comes?
        IF %extern clr true
        ELSE false THEN ;

: class? ( type -- type' flag )
     register? ?dup ?exit
     extern?   ?dup ?exit
     <auto> #keyword# comes?
        IF true exit THEN
     <static> #keyword# comes?
        IF %offset clr true
        ELSE false THEN ;


\ *** Block No. 77, Hexblock 4d

\   parser: type-specifiers    11sep94pz

defer 'class?

: or-type: ( cfa -- )  create ,
    does> ( type pfa -- type' flag )
     @ IS 'class?   extern off
     'class?
        IF type-name? drop  true
        ELSE type-name?
           IF 'class? drop  true
           ELSE false THEN THEN ;

' class? or-type: class-or-type?
' range? or-type: range-or-type?
' register? or-type: register-or-type?


\ *** Block No. 78, Hexblock 4e

\   parser: declarator         08mar91pz

create id-buf /id 1+ allot

: expect-id,ok?  ( -- tokenvalue true / -- false)
     #id# comes-a? dup IF accept
       ELSE ." identifier" *expected* error THEN ;

: id-to-buf  ( -- id-buf )
     expect-id,ok? IF id-buf over c@ 1+ cmove THEN id-buf ;

: id-to-local  ( -- local-entry )
     expect-id,ok?
     IF putlocal ELSE id-buf ( as dummy local-entry ) THEN ;

variable handle-id-xt  ' id-to-buf handle-id-xt !

doer (declarator ( type -- id-handle type' )

: param-ok? ( id-handle type -- id-handle type true )
            ( id-handle type -- false )
    array? []dim'd @ 0= and IF %l-value set THEN
    function? dup >r IF unnestlocal THEN
    array? r> or IF *param* error 2drop false ELSE true THEN ;

: parameter' ( id-buf type -- )
    param-ok? IF
      swap findparam ?dup 0=
        IF *undef* error drop ELSE >type ! THEN
    THEN ;

: typed-parameters) ( -- )
     handle-id-xt push  ['] id-to-local handle-id-xt !
     BEGIN %local register-or-type? not IF 2drop exit THEN
     (declarator  param-ok? IF 2 dyn-allot swap rot 2! THEN
     ascii , #char# comes? not UNTIL ;

: id-parameters) ( -- )
     BEGIN expect-id,ok? IF putlocal  2 dyn-allot %local  rot 2! THEN
     ascii , #char# comes? not UNTIL ;

: [parameters]) ( -- )
     dyn-reset
     ascii ) #char# comes? ?exit
     #id# comes-a? IF drop id-parameters) ElSE typed-parameters) THEN
     expect')' ;


\ *** Block No. 79, Hexblock 4f

\   parser: declarator         14mar91pz

: handle-function ( type -- type' )
     function?
        IF unnestlocal THEN
     %function is?
        *double-func* ?error
     %function set
     %pointer is?
        IF []dim'd @ *???* ?error
        []dim'd off  1 #/obj !
        %pointer clr  %l-value set
        ELSE %l-value clr THEN
     function?
        IF nestlocal [parameters])
        ELSE expect')'
        THEN ;


\ *** Block No. 80, Hexblock 50

\   parser: declarator         08mar91pz

: set-pointer ( type -- type' )
     %pointer is?  *double-ptr* ?error
     %pointer set ;

: handle-array ( type -- type' )
     ascii ] #char# comes? not
        IF %function is? >r
        constant-expression r>
           IF drop *???* error
           ELSE #/obj ! []dim'd on THEN
        expect']' THEN
     set-pointer  %function isn't?
        IF %l-value clr THEN ;

\ frueher:
\     set-pointer  %function is?
\        IF ascii ] #char# expect
\        ELSE %l-value clr
\        ascii ] #char# comes? not
\           IF constant-expression
\           #/obj !  []dim'd on
\           ascii ] #char# expect THEN
\        THEN ;


\ *** Block No. 81, Hexblock 51

\   parser: declarator         06mar91pz

make (declarator ( type -- id-handle type' )
     1 #/obj !  []dim'd off
    false BEGIN <*> #oper# comes? WHILE
     *double-ptr* ?error true REPEAT >r
     ascii ( #char# comes?  \ )
        IF recursive (declarator
           expect')'
        ELSE handle-id-xt perform swap THEN
     BEGIN mark >r
     ascii [ #char# comes?
        IF handle-array THEN
     ascii ( #char# comes?  \ )
        IF handle-function THEN
     r> advanced? not UNTIL
     r> IF set-pointer THEN ;

defer 'declarator ( type' -- )

: declarator ( type -- )
     id-buf off  (declarator 'declarator ;


\ *** Block No. 82, Hexblock 52

\   parser: declarator         12mar91pz

variable (1st
: 1st  (1st on ;
: 2nd  (1st off ;
: 1st? (1st @ ;


: declarator-list';' ( type -- )
     >r
     function not defined
     r@ 1st declarator
     function defined?
        IF rdrop exit THEN
     BEGIN ascii , #char# comes? WHILE
     r@ 2nd declarator REPEAT
     rdrop expect';' ;


\ *** Block No. 83, Hexblock 53

\   parser: static initialization

\ Because we allocate static variables from the top of the available
\ memory downwards, and we issue static init values downward, too,
\ accordingly, we need to issue array init values starting at the end
\ of the array, thus we need to reverse their order. That's why we
\ leave the init values on the stack instead of issuing them directly.

: 1more ( n -- n )
     teststack  1 #inits +! ;

do$: init$ ( -- values )
        noop 1more noop ;

: init[] ( -- values )
     BEGIN constant-expression 1more
     ascii } #char# comes? not WHILE
     ascii , #char# expect
     ascii } #char# comes?
        IF 0  1more  true
        ELSE false THEN
     UNTIL ;

: static-init ( type -- values )
     is-char? swap array? nip  ( is-char? array? )
     #string# comes-a?
        IF drop
        and 0= *!=type* ?error
        []init'd on  init$ accept exit THEN
     ascii { #char# comes?  \ }
        IF nip 0= *!=type* ?error
        []init'd on  init[] exit THEN
     2drop
     constant-expression 1more ;


\ *** Block No. 85, Hexblock 55

\   parser: declare-fcnt/data  14mar91pz

: check-types-equal ( type1 type2 -- )
     xor %decl.mask and
     *!=type* ?error ;

: declare ( id-buf type -- )
     swap findglobal ?dup
        IF >type @ check-types-equal
        ELSE drop *undef* error THEN ;

: extern-op?
     ( type -- type' flag )
     <*=> #oper# comes?
        IF function?
           IF %stdfctn set
           ELSE *syntax* error THEN
        true
        ELSE </=> #oper# comes? THEN ;

: define-extern ( id-buf type -- )
    function? IF unnestlocal THEN
    swap putglobal
    constant-expression -rot 2! ;


\ *** Block No. 86, Hexblock 56

\   parser: define-data        14mar91pz

: dim-array ( type -- type' )
     []dim'd @ 0=
        IF []init'd @
           IF #inits @ #/obj !
           ELSE %l-value set THEN
        THEN ;

: size/# ( type -- type n )
     %pointer %function + isn't? >r
     array? >r is-char? r> r> or and
     2+ ;


\ *** Block No. 87, Hexblock 57

\   parser: define-data        11sep94pz

defer 'stat,

: create-static
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

: create-dyn ( type -- obj )
     size/# #/obj @ *  dyn-allot swap ;


\ *** Block No. 89, Hexblock 59

\   parser: define-data        11sep94pz

defer 'putsymbol

: define-data ( id-buf type -- )
    extern @
       IF declare exit THEN
    #inits off  []init'd off
    %offset is?
      IF array? IF dim-array THEN
      create-dyn  <=> #oper# comes?
        IF size/# .size  constant-expression .lda#.s
        over .sta.s(base),# THEN
      ELSE <=> #oper# comes? IF dup >r static-init r> THEN
      array? IF dim-array THEN
      create-static THEN
    rot 'putsymbol 2! ;


\ *** Block No. 90, Hexblock 5a

\   parser: define function    25apr94pz

variable protos2resolve

: prototype ( id-buf type -- )
     unnestlocal
     over findglobal ?dup
        IF >type @ check-types-equal drop
        ELSE %proto set  .label swap
        rot putglobal  dup >r  2!
        heap> ?dup
           IF dup 2+  r> over !
                  2+  .jmp-ahead 1+ swap !
           protos2resolve hook-into
           ELSE rdrop THEN
        THEN ;

: init-patches
     protos2resolve off
     protos2patch   off ;

     init: init-patches


\ *** Block No. 91, Hexblock 5b

\   parser: define function    25apr94pz

: sort-in  ( addr2patch -- list )
     >r  protos2patch BEGIN
        dup @ 0= IF rdrop exit THEN
        dup @ 4 + @ r@ u<
                 IF rdrop exit THEN
        @ REPEAT ;

: adjust-prototype
    ( obj desc type -- obj desc )
     2 pick check-types-equal   >r
     ( obj )
     protos2resolve BEGIN dup @
        ( obj list/prev element )
        dup 0= *compiler* ?fatal
        2+ @ r@ - WHILE  @ REPEAT
     ( obj list/prev ) hook-out
     ( obj element)  2 pick over 2+ !
     dup 4 + @  sort-in  hook-into r> ;

: find/putglobal ( obj id-buf -- obj desc )
     dup findglobal ?dup
        IF dup >type @ %proto is?
           IF rot drop adjust-prototype exit
           ELSE 2drop THEN THEN
     putglobal ;


\ *** Block No. 92, Hexblock 5c

\   parser: define-function    14mar91pz

: declare-parameters ( -- )
     ['] parameter' IS 'declarator
     BEGIN %local
     register-or-type? WHILE
     declarator-list';' REPEAT drop ;


\ *** Block No. 93, Hexblock 5d

\   parser: define function    14mar91pz

: define-function ( id-buf type -- )
     #char# comes-a?
        IF dup ascii ; = swap ascii , = or
           IF prototype exit THEN THEN
     1st?
        IF .label swap rot find/putglobal 2!
         declare-parameters
          ascii { #char# expect  \ }
          compound
         unnestlocal
        .rts  flushcode
        function defined
        ELSE 2drop *syntax* error THEN ;


\ *** Block No. 94, Hexblock 5e

\   parser: type-specifiers    11sep94pz

: global  ( -- )
     ['] putglobal IS 'putsymbol ;

: local  ( -- )
     ['] putlocal IS 'putsymbol ;


: declaration' ( id-buf type -- )
     function?
        IF unnestlocal %offset clr %extern set declare
        ELSE local define-data THEN ;

: definition' ( id-buf type -- )
     extern-op?
        IF define-extern exit THEN
     function?
        IF define-function
        ELSE global define-data THEN ;


\ *** Block No. 95, Hexblock 5f

\   parser: declaration        14mar91pz

: declaration? ( -- flag )
     ['] declaration' IS 'declarator
     %local class-or-type?
        IF declarator-list';' true
        ELSE drop false THEN ;

: definition? ( -- flag )
     ['] definition' IS 'declarator
     %global range-or-type?
        IF declarator-list';' true
        ELSE #eof# comes?
           IF drop false
           ELSE mark >r
           declarator-list';'
           r> advanced? THEN THEN ;

||off

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
     fetchword
     BEGIN definition? not UNTIL
     " main" findglobal ?dup 0=
        IF main()-adr off exit THEN
     2@ function?
        IF drop main()-adr ! exit THEN
     *bad-main* fatal ;
