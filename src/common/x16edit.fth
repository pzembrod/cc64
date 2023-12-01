
$0001 || constant RomBank

|| Code (xed?  ( -- n )
  $c000 lda  pha  $c003 lda  Push jmp  end-code

|| Code (xed  ( -- )
  2 # ldx  $ff # ldy
  $4 lda  0= ?[ $c000 jsr ][ $c003 jsr ]?
  xyNext jmp  end-code

~ : xed  ( -- )
   bl word count $4 c!  $2 !
   RomBank c@  13 RomBank c!
   (xed? $4c4c = IF (xed RomBank c!
   ELSE RomBank c! ." no x16edit" THEN ;
