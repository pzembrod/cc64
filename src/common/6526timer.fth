
|| $dd00 >label CIA

~ Code reset-32bit-timer  ( -- )
    $ff # lda  CIA 4 + sta  CIA 5 + sta  CIA 6 + sta  CIA 7 + sta
    %11011001 # lda  CIA $f + sta
    %10010001 # lda  CIA $e + sta
    Next jmp  end-code

~ Code read-32bit-timer  ( -- ud )
    CIA $e + lda  pha  $fe and  CIA $e + sta
    SP 2dec  CIA 4 + lda  SP x) sta  CIA 5 + lda  SP )y sta
    SP 2dec  CIA 6 + lda  SP x) sta  CIA 7 + lda  SP )y sta
    pla  CIA $e + sta  Next jmp  end-code

~ Code reset-50ms-timer  ( -- )
    \ $c06e / 985248 Hz ( PAL C64 phi2 ) = 0.050 sec
    $6e # lda  CIA 4 + sta  $c0 # lda  CIA 5 + sta
    $ff # lda  CIA 6 + sta  CIA 7 + sta
    %11011001 # lda  CIA $f + sta
    %10010001 # lda  CIA $e + sta
    Next jmp  end-code

~ Code read-50ms-timer  ( -- u )
    CIA $e + lda  tax  $fe and  CIA $e + sta
    CIA 6 + lda  pha  CIA 7 + lda  CIA $e + stx
    Push jmp  end-code

~ : ms.  ( u -- )
      20 u/mod u. 5 * u. ." sec ms" ;
