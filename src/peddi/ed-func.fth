\ *** Block No. 18, Hexblock 12

\ variables & loadscreen       14sep94pz

| 17 constant /filename

|  variable 1.column
|  variable char
|  variable vir-char
|  variable blanklines
|  create filename  /filename allot
|  variable changed?
|  variable end?

| variable 1st-line>
| variable line>
| variable )text
| variable text(
| variable last-line>

| : char>  line> @ char @ + ;


\ *** Block No. 19, Hexblock 13

\   display                    02aug94pz

| create cstab
   $80 c,  $00 c,  $40 c,  $20 c,
   $c0 c,  $40 c,  $80 c,  $80 c,

| : cbm>scr  ( 8b1 -- 8b2 )
     dup $ff = IF drop $5e exit THEN
     dup $e0 and 2/ 2/ 2/ 2/ 2/
     cstab + c@ - $ff and ;


\ *** Block No. 20, Hexblock 14

\   display                    02sep94pz

| : key ( -- c )
     BEGIN pause c64key? UNTIL getkey ;

| 40   constant col/scr
(64 | 1024 constant scr> C)
(16 | 3072 constant scr> C)
\ | 1024 constant chr/scr
| scr> 1000 +    constant <scr
| <scr col/scr - constant last-row>
| ' scr> ALIAS 1st-row>
| 25   constant rows/scr

| variable csr.row>
| variable csr.col

| : col/scr*  2* 2* 2* dup 2* 2* + ;
| : th-row>  ( n -- adr )
     col/scr* scr> + ;

| : cursor> ( -- adr )
     csr.row> @ csr.col @ + ;
| : flip  ( -- ) $80 cursor> ctoggle ;


\ *** Block No. 21, Hexblock 15

\   display                    02sep94pz

| : (.line  ( line row -- )
     swap 1.column @ 0 ?DO dup c@ #cr =
        IF drop col/scr bl fill
        UNLOOP exit THEN  1+ LOOP
     ( row line ) over col/scr bounds
     DO ( row line ) dup c@ dup #cr =
        IF 2drop col/scr + I ?DO
        bl I c! LOOP UNLOOP exit THEN
     cbm>scr I c! 1+ LOOP 2drop ;

(64 | $d020 constant border C)
(16 | $ff19 constant border C)
| : half  ( n - )
     border c! pause $80 0 DO LOOP ;

    | 0 constant black
(64 | 1 constant white C)
(16 | $71 constant white C)
| : warn-signal ( -- )
     border push  white half  black half
                  white half  black half ;


\ *** Block No. 22, Hexblock 16

\ Here lived the assembler implementation of >prev/>nextline.

\ *** Block No. 23, Hexblock 17

\   display                    02sep94pz

| : >prevline  ( line> -- line'> )
     dup text( @ =
        IF drop line> @ exit THEN
     1- BEGIN dup text( @ = ?exit
              dup text[   = ?exit
     1- dup c@ #cr = UNTIL 1+ ;

| : >nextline  ( line> -- line'> )
     BEGIN dup c@ #cr - WHILE 1+ REPEAT
     1+ dup )text @ =
        IF drop text( @ THEN ;

\ | : >prevline ( line> -- line'> )
\      dup  >prevline1
\      swap (>prevline  over -
\         IF warn-signal THEN ;

\ | : >nextline ( line> -- line'> )
\      dup  >nextline1
\      swap (>nextline  over -
\         IF warn-signal THEN ;


\ *** Block No. 24, Hexblock 18

\   display                    31aug94pz

| : setcur ( scrline -- )
     csr.row> !
     char @ 1.column @ - csr.col !
     flip ;

\ : .line ( -- )
\    csr.row> @  line> @ over
\    (.line setcur ;

| : .screen ( -- )
     1st-line> @   <scr scr>
     DO dup I (.line
     dup line> @ = IF I setcur THEN
     >nextline dup ]text 1- =
        IF >prevline last-line> !
        I col/scr +  <scr over -
        dup col/scr / blanklines !
        bl fill UNLOOP exit THEN
     col/scr +LOOP
     >prevline last-line> !
     blanklines off ;


\ *** Block No. 25, Hexblock 19

\   display                    31aug94pz

| : scroll-right? ( --  flag )
     csr.col @ 0= ;

| : scroll-left? ( --  flag )
     csr.col @ col/scr 1- = ;

| 8 constant #tab

| : scroll-left ( -- )
     #tab 1.column +!    .screen ;

| : scroll-right ( -- )
     1.column @ #tab umin
     negate 1.column +!  .screen ;


| : mem?  ( n -- flag )
     )text @ + text( @ u>
     dup IF warn-signal THEN ;


\ *** Block No. 26, Hexblock 1a

\   display                    14sep94pz

| : .char ( c -- )  vir-char off
     1 mem? ?exit   changed? on
     scroll-left? IF scroll-left THEN
     char> dup 1+  )text @ 1+
     dup )text !   over - cmove>
     dup char> c!  1 char +!
     flip  cursor> dup 1+
     col/scr csr.col @ - 1- cmove>
     cbm>scr  cursor> c!
     1 csr.col +!  flip ;

| : .left  ( -- )   vir-char off
     char @ 0= ?exit
     scroll-right? IF scroll-right THEN
     -1 char +!
     flip -1 csr.col +! flip ;

| : .right  ( -- )  vir-char off
     char> 1+ )text @ = ?exit
     scroll-left? IF scroll-left THEN
     1 char +!
     flip  1 csr.col +!  flip ;


\ *** Block No. 27, Hexblock 1b

\   display                    14sep94pz

| : 1st-line-up ( -- )
     1st-line> @ >prevline
     1st-line> ! ;

| : 1st-line-down ( -- )
     1st-line> @ >nextline
     1st-line> ! ;

| : last-line-up ( -- )
     blanklines @
        IF -1 blanklines +!
        ELSE last-line> @
        >prevline last-line> ! THEN ;

| : last-line-down ( -- )
     last-line> @ >nextline
     dup ]text 1- = IF 1 blanklines +!
                    drop exit THEN
     last-line> ! ;


\ *** Block No. 28, Hexblock 1c

\   display                    31aug94pz

| : .vir-left  ( -- )
     )text @ line> @ - 1- >r
     vir-char @ 0=
        IF char @ r@ u>
           IF char @ vir-char !
           ELSE rdrop exit THEN  THEN
     vir-char @  dup r> umin char @ -
     ?dup 0= IF drop exit THEN >r
     r@ char @ + dup char !
     over = 0= and vir-char !
     r@ csr.col @ +  dup col/scr <
     swap -1 > and
        IF flip r> csr.col +! flip
        ELSE 1.column @ r> +
        dup 0< IF csr.col +!
               1.column off
               ELSE 1.column ! THEN
        .screen THEN ;


\ *** Block No. 29, Hexblock 1d

\   display                    13sep94pz

| : (del-line  ( line -- )
     dup col/scr + under
     <scr swap - cmove
     last-row> col/scr bl fill ;

| : line-up  ( -- )
     text( @  dup last-line> @ = >r
              ( from )   dup >nextline
     dup text( !         over - >r
     )text @ ( from to ) dup line> !
     dup r@ + )text !    r> cmove
     r> IF line> @ last-line> ! THEN ;

| : .down ( -- )
     text( @ 1+ ]text = ?exit
     line-up
     flip  csr.row> @ last-row> =
        IF scr> (del-line
        1st-line-down last-line-down
        last-line> @ last-row> (.line
        ELSE col/scr csr.row> +! THEN
     flip  .vir-left ;


\ *** Block No. 30, Hexblock 1e

\   display                    13sep94pz

| : (inst-line  ( line -- )
     dup  dup col/scr +
     <scr over - cmove>
          col/scr bl fill ;

| : line-down  ( -- )
     line> @  dup last-line> @ = >r
             )text @ over - >r
     text( @ r@ -  dup text( !
     r>  cmove>   line> @ dup )text !
     >prevline line> !
     r> IF text( @ last-line> ! THEN ;

| : .up ( -- )
     line> @ text[ = ?exit
     line-down
     flip  csr.row> @ scr> =
        IF 1st-line-up last-line-up
        scr> (inst-line
        1st-line> @ scr> (.line
        ELSE col/scr negate
        csr.row> +! THEN
     flip  .vir-left ;


\ *** Block No. 31, Hexblock 1f

\   display                    14sep94pz

| : .del-from  ( -- )
     vir-char off  changed? on
     char> #cr over c!  1+ )text !
     cursor> col/scr csr.col @ -
     bl fill  flip ;

| : .del-to  ( -- )
     vir-char off  changed? on
     line> @ char> over - bl fill
     csr.row> @ csr.col @ bl fill ;

| : .del-line  ( -- )
     .del-to .del-from ;


\ *** Block No. 32, Hexblock 20

\   display                    14sep94pz

| : (split-mem  ( -- )
     char> )text @ over -  over 1+ swap
     cmove>  #cr char> c!  1 )text +!
     char> 1+ line> !  char off ;

| : .split-line ( -- )  vir-char off
     1 mem? ?exit   changed? on
     line> @ last-line> @ =  (split-mem
        IF char> last-line> !
        blanklines @
           IF -1 blanklines +!
           ELSE 1st-line-down THEN
        ELSE last-line-up THEN
     1.column @ IF 1.column off
                .screen exit THEN
     cursor> col/scr csr.col @ - bl fill
     csr.col off
     csr.row> @ last-row> =
        IF 1st-row> (del-line
        ELSE col/scr csr.row> +!
        csr.row> @ (inst-line THEN
     line> @ csr.row> @ (.line  flip ;


\ *** Block No. 33, Hexblock 21

\   display                    15sep94pz

| : (join-mem  ( -- )
     line> @  dup >prevline >r
     dup r@ - 1- char !
( line )    )text @ over -   over 1-
( line len line-1 ) swap cmove   ( -- )
     -1 )text +!   r> line> !  ;

| : (join-1stlast  ( n -- )
     0 case? IF last-line-down exit THEN
     2 case? IF text( @ 1+ ]text =
                IF line> @ last-line> !
                1 blanklines +!
                ELSE text( @
                last-line> ! THEN
             exit THEN
     1 =     IF line> @ 1st-line> !
             exit THEN
     line> @ dup 1st-line> !
     last-line> ! 1 blanklines +! ;


\ *** Block No. 34, Hexblock 22

\   display                    14sep94pz

| : .join-lines  ( -- )  vir-char off
     line> @ text[ = ?exit
     changed? on
     line> @ 1st-line>  @ =  1 and
     line> @ last-line> @ =  2 and or
     (join-mem   (join-1stlast
     char @ 1.column @ -    ( csr.col )
     dup col/scr u<
        IF csr.col !
        csr.row> @  1st-row> -
           IF csr.row> @ (del-line
           col/scr negate csr.row> +!
           blanklines @ 0=
              IF last-line> @ last-row>
              (.line THEN
           THEN
        line> @ csr.row> @ (.line flip
        ELSE col/scr - #tab +
        1.column +! .screen THEN ;


\ *** Block No. 35, Hexblock 23

\   display                    14sep94pz

| : .del-under  ( -- )  vir-char off
     char> c@ #cr = ?exit
     changed? on
     char> dup 1+ swap )text @ 1-
     dup )text !  over - cmove
     cursor> dup 1+ swap
     col/scr csr.col @ - 1- cmove
     line> @ 1.column @ + col/scr + 1-
     dup )text @ 1- u<
        IF c@ ELSE drop bl THEN cbm>scr
     csr.row> @ col/scr + 1- c!
     flip ;

| : .del-left  ( -- )
     csr.col @
        IF .left .del-under
        ELSE .join-lines THEN  ;


\ *** Block No. 36, Hexblock 24

\   fold/unfold                31aug94pz

| : unfold  ( -- )
     char off  1.column off
     text[ dup 1st-line> ! dup line> !
     >nextline dup text( @ =
        IF drop exit THEN   ( from )
     )text @ over - >r  dup )text !
     text( @ r@ -       dup text( !
     r> cmove> ;

\ | : fold  ( -- )
\      text( @  ]text 1- over -
\      ?dup 0= IF drop exit THEN
\      )text @ swap   dup )text +!
\      cmove   ]text 1- text( ! ;


\ *** Block No. 37, Hexblock 25

\   loadtext                   17apr20pz

| : (loadtext  ( -- )
     #cr  ]text 1-  dup text( !
     dup 1- )text !  c!
     ]text 2- text[ DO i/o-status?
        IF I )text ! LEAVE THEN
     bus@ I c! LOOP
     )text @ dup 1- c@ #cr =
        IF drop ELSE #cr over c!
        1+ )text ! THEN  1 mem? drop ;

| : loadtext  ( -- )
     dev 2 busopen   dev 8 - (drv !
     filename count bustype
     " ,s,r"  count bustype busoff
     page  derror?
        IF dev 2 busclose
        changed? off  .screen
        exit THEN
     dev 2 busin  (loadtext  busoff
     dev 2 busclose
     changed? off  unfold  .screen ;


\ *** Block No. 38, Hexblock 26

\   savesystem                 18apr20pz

| : (savetext  ( -- flag )
     cr ." writing " filename
     count type cr cr
     dev 15 busout " s0:." count
     bustype filename count bustype
     busoff  dev 15 busout " r0:."
     count bustype filename count 2dup
     bustype ascii =  bus! bustype
     busoff   \ derror? ?dup ?exit
     dev 2 busopen filename count
     bustype " ,s,w" count bustype
     busoff  dev 2 busout
     text[   )text @  over - bustype
     text( @ ]text 1- over - bustype
     dev 2 busclose  derror? ;

| : savetext  ( -- )
     page (savetext
        IF ." write operation failed"
        cr key drop
        ELSE changed? off THEN
     .screen ;


\ *** Block No. 39, Hexblock 27

\   display                    31aug94pz

| : .bol  ( -- )
     char off  vir-char off  1.column @
        IF 1.column off .screen
        ELSE flip csr.col off flip
        THEN ;

| : .eol  ( -- )
     vir-char off
     )text @ 1- char> - dup >r  char +!
     csr.col @ r@ + col/scr - dup 0<
        IF drop flip r> csr.col +! flip
        ELSE 1+ 1.column +!
        rdrop .screen THEN ;

| : .cr  ( -- )
     .bol .down ;


\ *** Block No. 40, Hexblock 28

\   exit                       14sep94pz

| : (quit-ed  ( -- )  cr
." do you want to quit without saving ?"
     key ascii y = dup end? !
     0= IF .screen THEN ;

| : quit-ed  ( -- )
     page  changed? @
        IF (quit-ed ELSE end? on THEN ;

| : exit-ed  ( -- )
     page  changed? @
        IF (savetext
           IF (quit-ed exit THEN THEN
     end? on ;


\ *** Block No. 41, Hexblock 29

\   inst/delline               15sep94pz

| : .kill-line ( -- )
     vir-char off
     text( @ 1+ ]text = ?exit
     changed? on
     last-line-down
     line> @ )text ! line-up
     csr.row> @  (del-line
     blanklines @ 0=
       IF last-line> @ last-row>
       (.line THEN
     flip  .vir-left ;

| : .inst-line ( -- )
     vir-char off   1 mem? ?exit
     changed? on
     last-line> @ line> @ =
        IF 1 last-line> +! THEN
     char @ char off (split-mem char !
     line-down  last-line-up
     flip  csr.row> @ (inst-line
     flip  .vir-left ;


\ *** Block No. 42, Hexblock 2a

\   fast up/down               15sep94pz

| : n>prevline  ( line +n -- line' )
     0 DO dup text[ =
        IF UNLOOP exit THEN
     >prevline LOOP ;

| : n>nextline  ( line +n -- line' )
     0 DO dup >nextline  dup 1+ ]text =
        IF drop UNLOOP exit THEN
     nip LOOP ;


\ *** Block No. 43, Hexblock 2b

\   fast up/down               15sep94pz

| : n-line-down  ( +n -- )
     line> @ text[ = IF drop exit THEN
     line> @ swap n>prevline
     dup line> ! >nextline
     )text @ over - >r  dup )text !
     text( @ r@ - dup text( !
     r> cmove> ;

| : n-line-up  ( +n -- )
     text( @ dup rot n>nextline
     2dup = IF 2drop exit THEN
     over - >r  )text @  r@ cmove
     r@ )text +!  r> text( +!
     )text @ >prevline line> ! ;


\ *** Block No. 44, Hexblock 2c

\   fast up/down               15sep94pz

| : .20up  ( -- )
     1st-line> @ 20 n>prevline
     1st-line> !  20 n-line-down
     char off  .screen ;

| : .20down  ( -- )
     20 n-line-up
     1st-line> @ 20 n>nextline
     1st-line> !
     char off  .screen ;
