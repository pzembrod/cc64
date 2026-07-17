
$d020 constant bank-register  \ For testing purposes: C64 border color

variable current-bank

: bank-vocabulary1  ( n -- )
  current-bank !  vocabulary ;

: bank-vocabulary  ( n -- )
    Create  0 , 0 ,  here voc-link @ ,  voc-link !  ,
    Does>  dup 3 cells + @ current-bank !  context ! ;

: :b  Create: drop  current-bank @ c,  17
 ;Code \ here >recover !
               \ resolve fwd. reference
 RP 2dec IP    lda  RP X) sta
         IP 1+ lda  RP )Y sta
 RP 2dec bank-register  lda  RP X) sta
                  0  #  lda  RP )Y sta
 W lda  clc  2 # adc  IP sta
      txa   W 1+ adc  IP 1+ sta
 IP X) lda     bank-register sta
 IP inc  0= ?[ IP 1+ inc ]?
 Next jmp   end-code

Code r>bank
 RP X) lda  bank-register sta
 ' rdrop @ jmp   end-code

: b;        17 ?pairs  compile r>bank  compile unnest
 [compile] [ reveal ; immediate restrict

Code bexit2
 RP X) lda  bank-register sta
 iny
 RP )Y lda  IP sta
 iny
 RP )Y lda  IP 1+ sta
 dey dey
 4 # lda  ' rdrop @ 2+ jmp   end-code

: bexit  rdrop  r> bank-register c! ;

\ 1 bank-vocabulary parser
\ parser also definitions

\ compiler definitions

\ toss compiler definitions
