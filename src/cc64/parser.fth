\ *** Block No. 48, Hexblock 30

\ parser loadscreen            21sep94pz

  cr
  .( module parser: ) cr

|| : teststack  ( -- )
     here $80 + sp@ u> *stack* ?fatal
     up@ udp @ + $40 + rp@ u>
                      *rstack* ?fatal ;


\ *** Block No. 49, Hexblock 31

\ parser: tools                22feb91pz

|| : comes? ( word wordtype -- flag )
    nextword dnegate d+ or
    IF backword false ELSE true THEN ;

|| : comes-a? ( wordtype -- word true )
             ( wordtype -- false )
    nextword rot = dup not
    IF nip backword THEN ;

|| : expect ( word wordtype -- )
    2dup comes?
       IF 2drop
       ELSE *expected* error word.
       THEN ;

\ : skipword ( -- )
\    *ignored* error nextword word. ;


\ *** Block No. 50, Hexblock 32

  .( submodule expression ) cr

\ parser: atom                 13sep94pz

|| : cp$[ ( -- jmp adr )
     .jmp-ahead  .label ;

|| : cp]$ ( jmp adr -- adr )
     swap .resolve-jmp ;

~ do$: compile$  ( -- adr )
        cp$[ .byte cp]$ ;

\ obj in stack comments represents a data value in an expression and
\ consists of two values: obj = val type
\ val will be the actual value in case the expression so far is already
\ known at compile time, or a placeholder in case the value is only
\ known at run time.
\ type represents the data type of the value, a bitmap made up of the
\ definitions %int, %pointer, %function etc. from the beginning of
\ codegen.fth.

|| : atom ( -- obj )
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

|| doer expression
|| doer assign

|| : primary[] ( obj1 -- obj2 )
   value
   expression value  do-add
   do-pointer
   ascii ] #char# expect ;


\ *** Block No. 52, Hexblock 34

\   parser: primary            26apr20pz

|| : std-arguments ( -- )
     assign put-std-argument
     BEGIN ascii , #char# comes? WHILE
     assign drop-std-argument REPEAT ;

|| : arguments  ( -- )
     BEGIN assign put-argument
     ascii , #char# comes? not UNTIL ;

|| : primary() ( obj1 -- obj2 )
     %stdfctn is?
        IF ascii ) #char# comes? not
           IF std-arguments
           ascii ) #char# expect THEN
        do-std-call
        ELSE prepare-call
        ascii ) #char# comes? not
           IF arguments
           ascii ) #char# expect THEN
        do-call THEN ;


\ *** Block No. 53, Hexblock 35

\   parser: primary            11sep94pz

|| : primary ( -- obj )
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

|| : unary ( -- obj )  recursive

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

|| : comes-op? ( tab -- cfa true )
              ( tab -- false )
     #oper# comes-a?
        IF swap  dup 2+ swap @ bounds
        DO dup I @ =
          IF drop  I 2+ @  true
          UNLOOP exit THEN
        4 +LOOP
        backword THEN
     drop  false ;

|| : binary  ( tab -- )
    create , dup 4 * ,  0
     DO swap , , LOOP
    does>   ( tab -- obj )
     dup @ execute
     BEGIN 2 pick 2+ comes-op? WHILE >r
     value  2 pick @ execute value
     r> execute REPEAT
     2 roll drop ;

\ fuer assign wird 'von hand' eine
\ 'comes-op?'-tabelle angelegt !


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

|| : l-and ( -- obj )
     bit-or
     BEGIN  <l-and> #oper# comes? WHILE
     do-l-and.1  bit-or
     do-l-and.2  REPEAT ;

|| : l-or ( -- obj )
     l-and
     BEGIN  <l-or> #oper# comes? WHILE
     do-l-or.1  l-and
     do-l-or.2  REPEAT ;


\ *** Block No. 58, Hexblock 3a

\   parser: binary             07apr90pz

|| : conditional ( -- obj )
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

|| create assign-oper  11  4 * ,
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

\ hier wird eine tabelle angelegt,
\ die mit dem format der 'binary'-
\ tabellen uebereinstimmt, also
\ mit 'comes-op?' durchsucht wird.


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

  .( submodule statement ) cr

~ doer compound
|| doer statement

|| : expect';'  ascii ; #char# expect ;

|| : expression-stmt ( -- )
      expression  expect';' ;

|| : return-stmt ( -- )
      ascii ; #char# comes? not
         IF expression-stmt THEN
      .rts ;


\ *** Block No. 63, Hexblock 3f

\   parser: statement          22feb91pz

|| : (expression)  ( -- )
     ascii ( #char# expect
     expression
     ascii ) #char# expect ;

|| : if-stmt  ( -- )
     (expression)
     .jmz-ahead
     statement
     <else> #keyword# comes?
        IF .jmp-ahead swap .resolve-jmp
        statement THEN
     .resolve-jmp ;


\ *** Block No. 64, Hexblock 40

\   parser: statement          12mar91pz

|| : ?drop&exit ( n flag -- n / -- )
      IF drop rdrop THEN ;

|| : new  ( list -- )
     heap> ?dup 0= ?drop&exit
     dup 2+ off  swap hook-into ;

|| : resolve  ( list -- )
     BEGIN dup hook-out  dup >heap
     2+ @ ?dup WHILE
     .resolve-jmp REPEAT drop ;


\ *** Block No. 65, Hexblock 41

\   parser: statement          12mar91pz

|| variable breaks
|| variable conts

|| : another  ( list -- )
     dup @ 0= IF *ill-brk* error
              drop exit THEN
     heap> ?dup 0= ?drop&exit
     .jmp-ahead over 2+ !
     swap hook-into ;

|| : break-stmt ( -- )
     breaks another  expect';' ;

|| : continue-stmt ( -- )
     conts another  expect';' ;

~ : init-breaks  breaks off conts off ;
     init: init-breaks


\ *** Block No. 66, Hexblock 42

\   parser: statement          18apr94pz

|| variable switch-state ( 0/-1/def.adr)
|| variable cases

~ : init-switch   switch-state off
     cases off ;
    init: init-switch

|| : case-stmt ( -- )
     constant-expression
     ascii : #char# expect
     switch-state @ 0=   IF drop
        *noswitch* error exit THEN
     heap> ?dup 0= ?drop&exit
     dup  cases hook-into
     2+ .label over !  2+ ! ;

|| : default-stmt ( -- )
     ascii : #char# expect
     switch-state @ 1+
        IF *ill-default* error
        ELSE .label switch-state !
        THEN ;


\ *** Block No. 67, Hexblock 43

\   parser: statement          27may91pz

|| : cases-resolve ( -- )
     BEGIN cases hook-out  dup >heap
     2+ dup @ ?dup WHILE
     .word 2+ @ .word REPEAT
     drop  0 .word ;

|| : switch-stmt  ( -- )
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

\ $switch tay:pla:ina:sta zp:tya:ldy#0
\  [[ pha:lda(zp):ne?[[ sta vec:winc zp
\   pla:cmp(zp):eq?[ jmp(vec) ]?
\   winc zp ]]? winc zp:jmp(zp)


\ *** Block No. 68, Hexblock 44

\   parser: statement          22feb91pz

|| : do-stmt  ( -- )
     breaks new  conts new
     .label  statement  conts resolve
     <while> #keyword# expect
     (expression)  .jmn
     breaks resolve  expect';' ;

|| : while-stmt  ( -- )
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

|| : 2nd-expression? ( -- flag )
     ascii ; #char# comes? not dup
       IF expression  expect';' THEN ;

|| : 1st-expression  ( -- )
     2nd-expression? drop ;

|| : 3rd-expression  ( -- )
     ascii ) #char# comes? not
        IF expression
        ascii ) #char# expect THEN ;


\ *** Block No. 70, Hexblock 46

\   parser: statement          22feb91pz

|| : for-stmt ( -- )
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


\ *** Block No. 72, Hexblock 48

\   parser: statement          11sep94pz

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

  .( submodule definition ) cr

|| variable #/obj
|| variable []dim'd
|| variable #inits
|| variable []init'd

|| variable extern

|| : >type  ( desc -- desc.type )
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

|| : type-name? ( type -- type' flag )
     <char> #keyword# comes?
        IF set-char true
        ELSE <int> #keyword# comes?
           IF set-int true
           ELSE false THEN THEN ;

|| : register? ( type -- type' flag )
     <register> #keyword# comes?
        IF ( %register set ) true
        ELSE false THEN ;

|| : extern? ( type -- type' flag )
     <extern> #keyword# comes?
        IF %extern set  %offset clr
           extern on  true
        ELSE false THEN ;


\ *** Block No. 76, Hexblock 4c

\   parser: type-specifiers    14mar91pz

|| : range? ( type -- type' flag )
     extern? ?dup ?exit
     <static> #keyword# comes?
        IF %extern clr true
        ELSE false THEN ;

|| : class? ( type -- type' flag )
     register? ?dup ?exit
     extern?   ?dup ?exit
     <auto> #keyword# comes?
        IF true exit THEN
     <static> #keyword# comes?
        IF %offset clr true
        ELSE false THEN ;


\ *** Block No. 77, Hexblock 4d

\   parser: type-specifiers    11sep94pz

|| defer 'class?

|| : or-type: ( cfa -- )  create ,
    does> ( type pfa -- type' flag )
     @ IS 'class?   extern off
     'class?
        IF type-name? drop  true
        ELSE type-name?
           IF 'class? drop  true
           ELSE false THEN THEN ;

|| ' class? or-type: class-or-type?
|| ' range? or-type: range-or-type?
|| ' register? or-type: register-or-type?


\ *** Block No. 78, Hexblock 4e

\   parser: declarator         08mar91pz

|| create id-buf /id 1+ allot

|| : handle-id  ( -- )
     id-buf off  #id# comes-a?
        IF id-buf over c@ 1+ cmove
        ELSE *expected* error
        ." identifier" THEN ;


|| : [parameters]) ( -- )
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

|| : handle-function ( type -- type' )
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

|| : set-pointer ( type -- type' )
     %pointer is?  *double-ptr* ?error
     %pointer set ;

|| : handle-array ( type -- type' )
     ascii ] #char# comes? not
        IF %function is? >r
        constant-expression r>
           IF drop *???* error
           ELSE #/obj ! []dim'd on THEN
        ascii ] #char# expect THEN
     set-pointer  %function isn't?
        IF %reference clr THEN ;

\ frueher:
\     set-pointer  %function is?
\        IF ascii ] #char# expect
\        ELSE %reference clr
\        ascii ] #char# comes? not
\           IF constant-expression
\           #/obj !  []dim'd on
\           ascii ] #char# expect THEN
\        THEN ;


\ *** Block No. 81, Hexblock 51

\   parser: declarator         06mar91pz

|| : (declarator ( type -- type' )
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

|| defer 'declarator ( type' -- )

|| : declarator ( type -- )
     (declarator 'declarator ;


\ *** Block No. 82, Hexblock 52

\   parser: declarator         12mar91pz

|| variable (1st
|| : 1st  (1st on ;
|| : 2nd  (1st off ;
|| : 1st? (1st @ ;


|| : declarator-list';' ( type -- )
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

|| : 1more ( n -- n )
     teststack  1 #inits +! ;

|| : nomore ( n -- )  drop ;

|| defer '1more

|| : ?1more  ( flag -- )
        IF ['] 1more
        ELSE *initer* error
        ['] nomore THEN
     IS '1more ;

|| : >inittype ( type -- inittype )
     ( bit 0: int     bit 1: array   )
     ( bit 2: offset  bit 3: []dim'd )
     is-int? 1 and >r array? 2 and >r
     %offset is? 4 and nip r> or r> or
     []dim'd @ 8 and or ;

|| : (init$   >inittype 7 and 2 =
     dup []init'd !  ?1more ;


\ *** Block No. 84, Hexblock 54

\   parser: initializer        12mar91pz

|| : init[] ( type -- values )
     >inittype 6 and 2 =
     dup []init'd !  ?1more
     BEGIN constant-expression '1more
     ascii } #char# comes? not WHILE
     ascii , #char# expect
     ascii } #char# comes?
        IF 0  '1more  true
        ELSE false THEN
     UNTIL ;

|| do$: init$ ( type -- values )
        (init$ '1more noop ;

|| : initializer ( type -- values )
     ascii { #char# comes?  \ }
        IF init[] exit THEN
     #string# comes-a?
        IF drop init$ exit THEN
     >inittype 14 and 14 xor ?1more
     constant-expression '1more ;


\ *** Block No. 85, Hexblock 55

\   parser: declare-fcnt/data  14mar91pz

|| : check-types-equal ( type1 type2 -- )
     xor %decl.mask and
     *!=type* ?error ;

|| : declare ( type -- )
     id-buf findglobal ?dup
        IF >type @ check-types-equal
        ELSE drop *undef* error THEN ;

|| : extern-op?
     ( type -- type' flag )
     <*=> #oper# comes?
        IF function?
           IF %stdfctn set
           ELSE *syntax* error THEN
        true
        ELSE </=> #oper# comes? THEN ;

|| : define-extern ( type -- )
     %extern isn't? *???* ?error
     function? IF unnestlocal THEN
     constant-expression swap
     id-buf putglobal  2! ;


\ *** Block No. 86, Hexblock 56

\   parser: define-data        14mar91pz

|| : dim-array ( type -- type' )
     []dim'd @ 0=
        IF []init'd @
           IF #inits @ #/obj !
           ELSE %reference set THEN
        THEN ;

|| : size/# ( type -- type n )
     %pointer %function + isn't? >r
     array? >r is-char? r> r> or and
     2+ ;


\ *** Block No. 87, Hexblock 57

\   parser: define-data        11sep94pz

|| defer 'stat,

|| : create-static
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

|| : create-dyn ( [value] type -- obj )
     size/# #/obj @ *  dyn-allot swap
     #inits @
        IF size/# .size  rot .lda#.s
        over .sta.s(base),# THEN ;


\ *** Block No. 89, Hexblock 59

\   parser: define-data        11sep94pz

|| defer 'putsymbol

|| : define-data ( type -- )
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

|| : prototype ( type -- )
     unnestlocal
     id-buf findglobal ?dup
        IF >type @ check-types-equal
        ELSE %proto set  .label swap
        id-buf putglobal  dup >r  2!
        heap> ?dup
           IF dup 2+  r> over !
                  2+  .jmp-ahead 1+ swap !
           protos2resolve hook-into
           ELSE rdrop THEN
        THEN ;

~ : init-patches
     protos2resolve off
     protos2patch   off ;

     init: init-patches


\ *** Block No. 91, Hexblock 5b

\   parser: define function    25apr94pz

|| : sort-in  ( addr2patch -- list )
     >r  protos2patch BEGIN
        dup @ 0= IF rdrop exit THEN
        dup @ 4 + @ r@ u<
                 IF rdrop exit THEN
        @ REPEAT ;

|| : adjust-prototype
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

|| : find/putglobal ( obj -- obj desc )
     id-buf findglobal ?dup
        IF dup >type @ %proto is?
           IF adjust-prototype exit
           ELSE 2drop THEN THEN
     id-buf putglobal ;


\ *** Block No. 92, Hexblock 5c

\   parser: define-function    14mar91pz

|| : parameter' ( type -- )
     function? dup >r
        IF unnestlocal THEN
     array? r> or
        IF *param* error
        ELSE id-buf findparam
        ?dup 0= IF *undef* error drop
                ELSE >type ! THEN
        THEN ;

|| : declare-parameters ( -- )
     ['] parameter' IS 'declarator
     BEGIN %local
     register-or-type? WHILE
     declarator-list';' REPEAT drop ;


\ *** Block No. 93, Hexblock 5d

\   parser: define function    14mar91pz

|| : define-function ( type -- )
     #char# comes-a?
        IF backword
        dup ascii ; = swap ascii , = or
           IF prototype exit THEN THEN
     1st?
        IF .label swap
        find/putglobal 2!
         declare-parameters
          ascii { #char# expect  \ }
          compound
         unnestlocal
        .rts  flushcode
        function defined
        ELSE drop *syntax* error THEN ;


\ *** Block No. 94, Hexblock 5e

\   parser: type-specifiers    11sep94pz

|| : global  ( -- )
     ['] putglobal IS 'putsymbol ;

|| : local  ( -- )
     ['] putlocal IS 'putsymbol ;


|| : declaration' ( type -- )
     function?
        IF unnestlocal declare
        ELSE local define-data THEN ;

|| : definition' ( type -- )
     extern-op?
        IF define-extern exit THEN
     function?
        IF define-function
        ELSE global define-data THEN ;


\ *** Block No. 95, Hexblock 5f

\   parser: declaration        14mar91pz

|| : declaration? ( -- flag )
     ['] declaration' IS 'declarator
     %local class-or-type?
        IF declarator-list';' true
        ELSE drop false THEN ;

|| : definition? ( -- flag )
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
