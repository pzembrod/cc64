\ *** Block No. 84, Hexblock 54

\ vassembler loadscreen        20sep94pz

\ assembler for the virtual machine on which codegen is based
\ basicalls a slight abstraction, 16 bit, of the 6502.

\ $zp wird implizit benutzt von
\ - .not
\ - .mult .mult#
\ - .div  .div#  .#div
\ - .mod  .mod#  .#mod
\ - .add .sub .and .or  .xor
\ - .eq  .ne  .ge  .lt  .gt  .le
\ - .jmn  .jmn-ahead
\ - .jmz  .jmz-ahead


\ *** Block No. 85, Hexblock 55

\   vassembler: runtime        21aug94pz

||on

variable size   2 size !

variable o    $08c7 o !
\ hibyte: offset-^ ^-lobyte: kennbyte
: rt ( -- )  o @ constant
         $0300 o +! ;
\ offs +=3-^ ^-kennbyte nicht aendern

rt $jmp(zp)
rt $switch
rt $mult
rt $divmod
rt $shl
rt $shr
rt $jmp(fastcall)

\ *** Block No. 86, Hexblock 56

\   vassembler: parameter      25may91pz

$ff07 constant &
$ff17 constant &+1
  $27 constant <&
  $37 constant >&
  $47 constant $zp
  $57 constant $zp+1
  $67 constant $base
  $77 constant $base+1
: w:  $87 c, 21 ;
: ;w  21 ?pairs $97 c, ;
: b:  $a7 c, 22 ;
: ;b  22 ?pairs $b7 c, ;

: (wb:   ( par I endcode -- step )
           >r nip dup BEGIN 1+ dup c@
           r@ = UNTIL swap - 1+ rdrop ;
          ( par I -- step )
: (;wb  2drop 1 ;
: (w:   size @ 2- IF $97 (wb:
                    ELSE (;wb THEN ;
: (b:   size @ 1- IF $b7 (wb:
                    ELSE (;wb THEN ;


\ *** Block No. 87, Hexblock 57

\   vassembler: parameter ausw. 25may91pz

           ( par I -- step )
: 0+w,   drop     w,          2 ;
: 1+w,   drop  1+ w,          2 ;
: <b,    drop >lo b,          1 ;
: >b,    drop >hi b,          1 ;
: zp,    2drop >zp @    b,    1 ;
: zp+1,  2drop >zp @ 1+ b,    1 ;
: ba,    2drop >frame @    b, 1 ;
: ba+1,  2drop >frame @ 1+ b, 1 ;
: rt,    1+ c@ >runtime @ + w,
                          drop  2 ;

: compiler-error  *compiler* fatal ;

create atab
 ' 0+w, ,  ' 1+w, ,  ' <b, ,  ' >b, ,
 ' zp, ,  ' zp+1, ,  ' ba, ,  ' ba+1, ,
 ' (w: ,  ' (;wb ,   ' (b: ,  ' (;wb ,
 ' rt, ,
 ' compiler-error dup dup , , ,


\ *** Block No. 88, Hexblock 58

\   vassembler: a: a&: ;a      26may91pz

: (a: ( -- sys )
     create  here 0 c, 20 assembler ;

: ;a ( sys -- )
     20 ?pairs  current @ context !
     here over - 1- swap c! ;

: a, ( par I b -- step )
     dup $f and $7 =
        IF 2/ 2/ 2/ 2/ 2*
        atab + @ execute
        ELSE b, 2drop 1 THEN ;

: a&: (a: does> ( par pfa -- )
     count bounds
     DO dup I dup c@ a, +LOOP drop ;

: a: (a: does> ( pfa -- )
     count bounds
     DO 0 I dup c@ a, +LOOP ;


\ *** Block No. 89, Hexblock 59

\   vassembler: basics         26may91pz

a&: .lda#   <& # lda  >& # ldx  ;a

a: .pha     pha tay txa pha tya  ;a
a: .pha'    pha     txa pha      ;a
a: .pla     pla     tax pla      ;a

' w, ALIAS .word
' b, ALIAS .byte

a&: .jsr    & jsr  ;a
a:  .jsr(zp)  $jmp(zp) jsr ;a
a:  .jsr(fastcall)  $jmp(fastcall) jsr ;a
a:  .rts    rts ;a

a&: .ldy#   <& # ldy ;a
      ' .ldy#
ALIAS .args

a: .shla  .a asl tay txa
            .a rol tax tya ;a
a: .shra  tay txa .a lsr
            tax tya .a ror ;a
a: .and#255  0 # ldx ;a


\ *** Block No. 90, Hexblock 5a

\   vassembler: basics         24may91pz

a: .pop-zp  tay pla $zp+1 sta
                  pla $zp   sta  tya ;a
a: .sta-zp  $zp sta  $zp+1 stx ;a
a: .lda-zp  $zp lda  $zp+1 ldx ;a

a: .lda-base $base lda $base+1 ldx ;a

a&: .link#  tay clc   $base lda
              <& # adc  $base sta
              $base+1 lda  >& # adc
              $base+1 sta  tya ;a

a: .switch  $switch jsr ;a


\ *** Block No. 91, Hexblock 5b

\   vassembler: arithmetics    27may91pz

a: .not  $zp stx  0 # ldx  $zp ora
           0= ?[ dex ]? txa ;a

a: .neg  $ff # eor tay txa
           $ff # eor tax
           iny 0= ?[ inx ]? tya ;a

a: .inv  $ff # eor tay txa
           $ff # eor tax tya ;a


\ *** Block No. 92, Hexblock 5c

\   vassembler: arithmetics    27may91pz

a&: .add#   clc  <& # adc  tay  txa
              >& # adc  tax  tya  ;a

a&: .sub#   sec  <& # sbc  tay  txa
              >& # sbc  tax  tya  ;a

a&: .#sub   sec  $ff # eor  <& # adc
              tay  txa  $ff # eor
              >& # adc  tax  tya  ;a

a&: .and#   <& # and  tay  txa
              >& # and  tax  tya  ;a

a&: .or#    <& # ora  tay  txa
              >& # ora  tax  tya  ;a

a&: .xor#   <& # eor  tay  txa
              >& # eor  tax  tya  ;a


\ *** Block No. 93, Hexblock 5d

\   vassembler: arithmetics    24may91pz

a: .add-zp  clc  $zp adc  tay  txa
                 $zp+1 adc  tax  tya ;a

a: .sub-zp  sec  $zp sbc  tay  txa
                 $zp+1 sbc  tax  tya ;a

a: .and-zp    $zp and  tay  txa
              $zp+1 and  tax  tya  ;a

a: .or-zp     $zp ora  tay  txa
              $zp+1 ora  tax  tya  ;a

a: .xor-zp    $zp eor  tay  txa
              $zp+1 eor  tax  tya  ;a

 : .add  .sta-zp  .pla  .add-zp ;
 : .sub  .sta-zp  .pla  .sub-zp ;
 : .and  .sta-zp  .pla  .and-zp ;
 : .or   .sta-zp  .pla  .or-zp  ;
 : .xor  .sta-zp  .pla  .xor-zp ;


\ *** Block No. 94, Hexblock 5e

\   vassembler: arithmetics    24may91pz

a&: .ldzp#  tay  <& # lda    $zp sta
                   >& # lda  $zp+1 sta
              tya  ;a
a: (.mult    $mult   jsr ;a
a: (.divmod  $divmod jsr ;a

: .mult#  .sta-zp  .lda#  (.mult ;
: .mult   .sta-zp  .pla   (.mult ;

: .div#   .ldzp#  (.divmod ;
: .#div   .sta-zp  .lda#  (.divmod ;
: .div    .sta-zp  .pla   (.divmod ;

: .mod#   .div#  .lda-zp ;
: .#mod   .#div  .lda-zp ;
: .mod    .div   .lda-zp ;


\ *** Block No. 95, Hexblock 5f

\   vassembler: arithmetics    27may91pz

a: .tay   tay ;a
a: (.shl  $shl jsr ;a
a: (.shr  $shr jsr ;a

: .shl   .tay   .pla   (.shl ;
: .shl#  .ldy#         (.shl ;
: .#shl  .tay   .lda#  (.shl ;

: .shr   .tay   .pla   (.shr ;
: .shr#  .ldy#         (.shr ;
: .#shr  .tay   .lda#  (.shr ;

\ 'unsized' in/decrements
\ ~ a&: .incr  & inc  0= ?[ &+1 inc ]? ;a
\ ~ a&: .decr  & ldy  0= ?[ &+1 dec ]?
\              & dec ;a

\ ~ a&: .2incr  & ldy  $fe # cpy
\               cs ?[ &+1 inc ]?
\               & inc  & inc    ;a
\ ~ a&: .2decr  & ldy    2 # cpy
\               cc ?[ &+1 dec ]?
\               & dec  & dec    ;a

\ *** Block No. 96, Hexblock 60

\   vassembler: arithmetics    24may91pz

a&: .cmp#  0 # ldy   >& # cpx
             sec 0< ?[ clc ]?
             0= ?[ <& # cmp ]? ;a

a: .cmp-zp 0 # ldy   $zp+1 cpx
             sec 0< ?[ clc ]?
             0= ?[ $zp   cmp ]? ;a
 : .cmp .sta-zp .pla .cmp-zp ;


a: (.eq   0=  ?[ dey ]? tya tax  ;a
a: (.ne   0<> ?[ dey ]? tya tax  ;a
a: (.ge   cs  ?[ dey ]? tya tax  ;a
a: (.lt   cc  ?[ dey ]? tya tax  ;a
a: (.gt   cs  ?[ 0<> ?[ dey ]? ]?
                          tya tax  ;a
a: (.le   here 4 + bcc  0= ?[ dey ]?
                          tya tax  ;a


\ *** Block No. 97, Hexblock 61

\   vassembler: arithmetics    24may91pz

: .eq   .cmp    (.eq ;
: .ne   .cmp    (.ne ;
: .eq#  .cmp#   (.eq ;
: .ne#  .cmp#   (.ne ;

: .ge   .cmp    (.ge ;
: .lt   .cmp    (.lt ;
: .ge#  .cmp#   (.ge ;
: .lt#  .cmp#   (.lt ;

: .gt   .cmp    (.gt ;
: .le   .cmp    (.le ;
: .gt#  .cmp#   (.gt ;
: .le#  .cmp#   (.le ;


\ *** Block No. 98, Hexblock 62

\   vassembler: 'sized'        18apr94pz

: .size  size ! ;
\ evtl noch bei size <>1,2 : error

a&: .lda#.s
   <& # lda  w: >& # ldx ;w ;a


a&: .lda.s
   & lda w: &+1 ldx ;w b: 0 # ldx ;b ;a

a&: .sta.s  & sta  w: &+1 stx ;w ;a


a: .lda.s(zp)
   w: 1 # ldy  $zp )y lda  tax  dey ;w
   b: 0 # ldx 0 # ldy ;b  $zp )y lda ;a

a: .sta.s(zp)
   0 # ldy  $zp )y sta  w: pha txa
       iny  $zp )y sta     pla ;w ;a


\ *** Block No. 99, Hexblock 63

\   vassembler: 'sized'        18apr94pz

a&: .lda(base),&
   <& # ldy  $base )y lda  w: tax dey
             $base )y lda ;w
    b: 0 # ldx ;b ;a

: .lda.s(base),#
      dup 254 u>
        IF .lda-base  .add#
           .sta-zp    .lda.s(zp)
        ELSE size @ 1- IF 1+ THEN
           .lda(base),& THEN ;


a&: .sta(base),&
   <& # ldy  $base )y sta  w: pha txa
        iny  $base )y sta     pla ;w ;a

: .sta.s(base),#
      dup 254 u>
        IF .pha'  .lda-base  .add#
           .sta-zp  .pla  .sta.s(zp)
        ELSE .sta(base),& THEN ;


\ *** Block No. 100, Hexblock 64

\   vassembler: 'sized'        27may91pz

a&: .incr.s
       & inc w: 0= ?[ &+1 inc ]? ;w ;a

a&: .decr.s
       w: & ldy  0= ?[ &+1 dec ]? ;w
       & dec ;a

a&: .2incr.s
       w: & ldy  $fe # cpy
       cs ?[ &+1 inc ]? ;w
       & inc  & inc ;a

a&: .2decr.s
       w: & ldy    2 # cpy
       cc ?[ &+1 dec ]? ;w
       & dec  & dec ;a


\ *** Block No. 101, Hexblock 65

\   vassembler: jumps          24may91pz

a&: .jmp  & jmp ;a
       ' pc
ALIAS .label

: .jmp-ahead    pc  0 .jmp ;
: .resolve-jmp  pc swap 1+ w! ;

a: .skip0<>   $zp stx  $zp ora
                here 5 + bne ;a
a: .skip0=    $zp stx  $zp ora
                here 5 + beq ;a

: .jmz        .skip0<>  .jmp ;
: .jmn        .skip0=   .jmp ;

: .jmz-ahead  .skip0<>  .jmp-ahead ;
: .jmn-ahead  .skip0=   .jmp-ahead ;

||off
