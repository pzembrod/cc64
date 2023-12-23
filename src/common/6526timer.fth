
|| $dd00 >label CIA
|| CIA 4 + >label timerAlo
|| CIA 5 + >label timerAhi
|| CIA 6 + >label timerBlo
|| CIA 7 + >label timerBhi
|| CIA $e + >label timerActrl
|| CIA $f + >label timerBctrl

~ create prevTime  4 allot
~ create deltaTime 4 allot

~ Code reset-32bit-timer  ( -- )
    $ff # lda  timerAlo sta  timerAhi sta  timerBlo sta  timerBhi sta
    %11011001 # lda  timerBctrl sta
    %10010001 # lda  timerActrl sta
    Next jmp  end-code

~ Code read-32bit-timer  ( -- ud )
    timerActrl lda  pha  $fe # and  timerActrl sta
    SP 2dec  timerAlo lda  SP x) sta  timerAhi lda  SP )y sta
    SP 2dec  timerBlo lda  SP x) sta  timerBhi lda  SP )y sta
    pla  timerActrl sta  Next jmp  end-code

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

current @ context @
Assembler also definitions

~ : calcTime
  sec
  prevTime 2+ lda  timerAlo sbc  deltaTime 2+ sta
  prevTime 3+ lda  timerAhi sbc  deltaTime 3+ sta
  prevTime    lda  timerBlo sbc  deltaTime    sta
  prevTime 1+ lda  timerBhi sbc  deltaTime 1+ sta
;

~ : setPrevTime
  timerAlo lda  prevTime 2+ sta
  timerAhi lda  prevTime 3+ sta
  timerBlo lda  prevTime    sta
  timerBhi lda  prevTime 1+ sta
;

toss  context ! current !
