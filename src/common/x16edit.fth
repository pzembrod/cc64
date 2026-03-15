
$0001 || constant RomBank

|| Code (xed?  ( -- n )
  $c000 lda  pha  $c003 lda  Push jmp  end-code

|| Code (xed  ( -- )
  2 # ldx  $ff # ldy  \ first and last RAM bank to use
  $c006 jsr
  xyNext jmp  end-code

~ : xed  ( -- )
   bl word count $4 c!  $2 !
   $5 7 erase  dev $8 c!
   RomBank c@  13 RomBank c!
   (xed? $4c4c = IF (xed RomBank c!
   ELSE RomBank c! ." no x16edit" THEN ;
