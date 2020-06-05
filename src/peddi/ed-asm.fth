
\ *** Block No. 19, Hexblock 13

\   display                    02aug94pz

Label (cbm>scr
 N 8 + sta $7F # and $20 # cmp
 CS ?[ $40 # cmp
    CS ?[ $1F # and  N 8 + bit
       0< ?[ $40 # ora  ]?  ]?  rts  ]?
 Ascii . # lda  rts

| Code cbm>scr  ( 8b1 -- 8b2 )
 SP X) lda  (cbm>scr jsr  SP X) sta
 Next jmp  end-code


\ *** Block No. 22, Hexblock 16

\   display                    02sep94pz

| Code (>prevline  ( line> -- line'> )
   SP )y lda  tay  SP x) lda
   text( cmp 0= ?[ text( 1+ cpy ]?
   0= ?[ line> lda  line> 1+ ldy
Label end  SP x) sta  tya  1 # ldy
           SP )y sta  Next jmp ]?
   sec  1 # sbc  cc ?[ dey ]?
   [[ text( cmp  0= ?[ text( 1+ cpy ]?
   end beq
   >text[ cmp  0= ?[ >text[ 1+ cpy ]?
   end beq   sec  1 # sbc  cc ?[ dey ]?
   N sta  N 1+ sty N x) lda  #cr # cmp
   0= ?]  clc  1 # adc  0= ?[ iny ]?
   end jmp  end-code

| Code (>nextline  ( line> -- line'> )
   SP x) lda N sta  SP )y lda N 1+ sta
   [[ N x) lda  #cr # cmp  0<> ?[[
   N winc ]]?
   N 1+ ldy  N inc  0= ?[ iny ]?  N lda
   )text cmp 0= ?[ )text 1+ cpy ]?
   0= ?[ text( lda  text( 1+ ldy ]?
   SP x) sta  tya  1 # ldy  SP )y sta
   Next jmp  end-code

