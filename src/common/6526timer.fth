
|| $dd00 >label CIA
|| CIA 4 + >label timerAlo
|| CIA 5 + >label timerAhi
|| CIA 6 + >label timerBlo
|| CIA 7 + >label timerBhi
|| CIA $e + >label timerActrl
|| CIA $f + >label timerBctrl

~ Code reset-50ms-timer  ( -- )
    \ $c06e / 985248 Hz ( PAL C64 phi2 ) = 0.050 sec
    $6e # lda  timerAlo sta  $c0 # lda  timerAhi sta
    $ff # lda  timerBlo sta  timerBhi sta
    %11011001 # lda  timerBctrl sta
    %10010001 # lda  timerActrl sta
    Next jmp  end-code

~ Code read-50ms-timer  ( -- u )
    timerActrl lda  tax  $fe # and  timerActrl sta
    timerBlo lda  pha  timerBhi lda  timerActrl stx
    Push jmp  end-code

~ : ms.  ( u -- )
      20 u/mod u. 5 * u. ." sec ms" ;
