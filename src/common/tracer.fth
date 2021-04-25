\ *** Block No. 47, Hexblock 2f

\ tracer: loadscreen          cas16aug06

Onlyforth

\needs Code include trns6502asm.fth

\needs Tools   Vocabulary Tools

Tools also definitions

\ This nice Forth Tracer has been
\ developed by B. Pennemann and co
\ for Atari ST. CL Vogt has ported it
\ back to the volksForth 6502 C-16 and
\ C-64


\ *** Block No. 48, Hexblock 30

\ tracer: wcmp variables      clv04aug87

Assembler also definitions

: wcmp ( adr1 adr2--) \ Assembler-Macro
 over lda dup cmp swap  \ compares word
 1+   lda 1+  sbc ;


Only Forth also Tools also definitions

| Variable (W
| Variable <ip      | Variable ip>
| Variable nest?    | Variable trap?
| Variable last'    | Variable #spaces


\ *** Block No. 49, Hexblock 31

\ tracer:cpush oneline        cas16aug06

| Create cpull    0  ]
 rp@ count 2dup + rp! r> swap cmove ;

: cpush  ( addr len -)
 r> -rot   over  >r
 rp@ over 1+ - dup rp!  place
 cpull >r  >r ;

| : oneline  &82 allot keyboard display
 .status  space  query  interpret
 -&82 allot  rdrop
 ( delete quit from tnext )  ;

: range ( adr--) \ gets <ip ip>
 ip> off  dup <ip !
 BEGIN 1+ dup @
   [ Forth ] ['] unnest = UNTIL
 3+ ip> ! ;


\ *** Block No. 50, Hexblock 32

\ tracer:step tnext           clv04aug87

| Code step
 $ff # lda trap? sta trap? 1+ sta
           RP X) lda  IP sta
 RP )Y lda  IP 1+ sta  RP 2inc
 (W lda  W sta   (W 1+ lda   W 1+ sta
Label W1-  W 1- jmp  end-code

| Create: nextstep step ;

Label  tnext IP 2inc
 trap? lda  W1- beq
 nest? lda 0=  \ low(!)Byte test
 ?[ IP <ip wcmp W1- bcc
    IP ip> wcmp W1- bcs
 ][ nest? stx  \ low(!)Byte clear
 ]?
  trap? dup stx 1+ stx \ disable tracer
  W lda  (W sta    W 1+ lda   (W 1+ sta


\ *** Block No. 51, Hexblock 33

\ tracer:..tnext              clv12oct87

 ;c: nest? @
 IF nest? off r> ip> push <ip push
    dup 2- range
    #spaces push 1 #spaces +! >r THEN
 r@  nextstep >r
 input push    output push
 2- dup last' !
 cr #spaces @ spaces
 dup 4 u.r @ dup 5 u.r space
 >name .name  $10 col - 0 max spaces .s
 state push  blk push  >in push
 [ ' 'quit      >body ] Literal  push
 [ ' >interpret >body ] Literal  push
 #tib push  tib #tib @ cpush  r0 push
 rp@ r0 !
 ['] oneline Is 'quit  quit ;


\ *** Block No. 52, Hexblock 34

\ tracer:do-trace traceable   cas16aug06

| Code do-trace \ installs TNEXT
 tnext 0 $100 m/mod
     # lda  Next $c + sta
     # lda  Next $b + sta
 $4C # lda  Next $a + sta  Next jmp
end-code

| : traceable ( cfa--<IP ) recursive
 dup @
 ['] :    @ case? IF >body     exit THEN
 ['] key  @ case? IF >body c@ Input  @ +
                   @ traceable exit THEN
 ['] type @ case? IF >body c@ Output @ +
                   @ traceable exit THEN
 ['] r/w  @ case? IF >body
                   @ traceable exit THEN
 @  [ ' Forth @ @ ] Literal =
                  IF @ 3 + exit THEN
 \ for defining words with DOES>
 >name .name ." can't be DEBUGged"
 quit ;


\ *** Block No. 53, Hexblock 35

\ tracer:User-Words           cas16aug06

: nest   \ trace into current word
 last' @ @ traceable drop nest? on ;

: unnest \ proceeds at calling word
 <ip on ip> off ; \ clears trap range

: endloop last' @ 4 + <ip ! ;
\ no trace of next word to skip LOOP..

' end-trace Alias unbug \ cont. execut.

: (debug  ( cfa-- )
 traceable range
 nest? off trap? on #spaces off
 Tools do-trace ;

Forth definitions

: debug  ' (debug ; \ word follows

: trace'            \ word follows
 ' dup (debug execute end-trace ;


\ *** Block No. 54, Hexblock 36

\ tools for decompiling,      clv12oct87

( interactive use                      )

Onlyforth Tools also definitions

| : ?:  ?cr dup 4 u.r ." :"  ;
| : @?  dup @ 6 u.r ;
| : c?  dup c@ 3 .r ;
| : bl  $24 col - 0 max spaces ;

: s  ( adr - adr+)
 ( print literal string)
 ?:  space c? 4 spaces dup count type
 dup c@ + 1+ bl  ;  ( count + re)

: n  ( adr - adr+2)
 ( print name of next word by its cfa)
 ?: @? 2 spaces
 dup @ >name .name 2+ bl ;

: k  ( adr - adr+2)
 ( print literal value)
 ?: @? 2+ bl ;


\ *** Block No. 55, Hexblock 37

( tools for decompiling, interactive   )

: d  ( adr n - adr+n) ( dump n bytes)
 2dup swap ?: 3 spaces  swap 0
 DO  c? 1+ LOOP
 4 spaces -rot type bl ;

: c  ( adr - adr+1)
 ( print byte as unsigned value)
 1 d ;

: b  ( adr - adr+2)
 ( print branch target location )
 ?: @? dup @  over + 6 u.r 2+ bl  ;

( used for : )
( Name String Literal Dump Clit Branch )
( -    -      -       -    -    -      )


Onlyforth
