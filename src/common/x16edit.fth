
$9f60 >label RomBank

|| Code (xed  ( -- )
  RomBank lda  pha  7 # lda  RomBank sta
  2 # ldx  $ff # ldy  $c000 jsr
  pla  RomBank sta  xyNext jmp  end-code

|| Code (xed-with-file  ( -- )
  RomBank lda  pha  7 # lda  RomBank sta
  2 # ldx  $ff # ldy  $c003 jsr
  pla  RomBank sta  xyNext jmp  end-code

~ : xed  ( -- )
   bl word count ?dup
     IF 4 c!  2 !  (xed-with-file
     ELSE drop  (xed THEN ;
