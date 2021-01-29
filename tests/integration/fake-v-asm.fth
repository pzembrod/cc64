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
