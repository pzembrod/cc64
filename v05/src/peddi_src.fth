
\ *** Block No. 0, Hexblock 0

\ simple forth textfile editor 10sep94pz


testload         3
peddi4cc64       4
standalone       5
test3            6
whichkey         7
logo             8
shell            9
frame          &12
edit           &18


testinclude   &150











\ *** Block No. 1, Hexblock 1

\ memory settings for cc64     14sep94pz

  save
  $cbd0 set-himem
  $c000 ' limit >body !
  0 ink-pot !  15 ink-pot 2+ c!
  1024 1024 set-stacks



















\ *** Block No. 2, Hexblock 2

\ memory settings standalone   07may95pz

  save

| : relocate-tasks  ( newUP -- )
 up@ dup BEGIN  1+ under @ 2dup -
 WHILE  rot drop  REPEAT  2drop ! ;

| : relocate  ( stacklen rstacklen -- )
 empty  256 max 8192 min  swap
 256 max 8192 min  pad + 256 +
 2dup + 2+ limit u>
 abort" stacks beyond limit"
 under  +   origin $A + !        \ r0
 dup relocate-tasks
 up@ 1+ @   origin   1+ !        \ task
       6 -  origin  8 + ! cold ; \ s0

  $cbd0 ' limit >body !
  0 ink-pot !  15 ink-pot 2+ c!
  256 256 relocate





\ *** Block No. 3, Hexblock 3

\ peddi loadscreen test        15sep94pz

  : | ;

  onlyforth  decimal
  vocabulary peddi
  vocabulary shell
  peddi also definitions

   create dev#  8 c,
  : dev  dev# c@ ;

\ : text[   r0 @ ;
\ ' limit ALIAS ]text
create text[ 4000 allot
here constant ]text
  18 load   \ editor functions
  12 load   \ editor framework
\\
  shell also definitions

' ed ALIAS ed

  8 10 thru  \ shell & savesystem


\ *** Block No. 4, Hexblock 4

\ peddi loadscreen for cc64    07may95pz

  onlyforth  decimal
| vocabulary peddi
  compiler also peddi also definitions

| ' lomem    alias text[
| ' himem    alias ]text
| ' dev      alias dev

  onlyforth peddi also definitions

  18 load   \ editor functions
  12 load   \ editor framework

  shell also definitions

' ed ALIAS ed

   6 load   \ combined logo

   1 load   \ save & set memory




\ *** Block No. 5, Hexblock 5

\ peddi loadscreen standalone  07may95pz

  onlyforth  decimal
| vocabulary peddi
  vocabulary shell
  peddi also definitions

|  create dev#  8 c,
| : dev  dev# c@ ;

| : text[   r0 @ ;
| ' limit ALIAS ]text

  18 load   \ editor functions
  12 load   \ editor framework

  shell also definitions

' ed ALIAS ed

' bye ALIAS bye

  7 10 thru  \ shell & savesystem
  2 load     \ set memory


\ *** Block No. 6, Hexblock 6

\   combined logo              14apr20pz

| : .logo  ( -- )
   [ ' 'restart >body @ , ]
   ." peddi text editor V0.3 present"
   cr ;

' .logo IS 'restart


















\ *** Block No. 7, Hexblock 7

\   shell: cold' logo          14apr20pz

| create charset    here here 2- !
   also assembler   here 6 +  $20 c, ,
   xyNext $4c c, ,  $cbfa     $6c c, ,
   toss

\needs 2@  | : 2@  dup 2+ @ swap @ ;

| : init-shell  ( -- )
     only shell
     $cbfc 2@  $65021103. d=
        IF charset THEN ;

' init-shell IS 'cold

| : .logo  ( -- )
     ."     running" cr
     ." peddi text editor V0.3" cr
     ." 1995 by Philip Zembrod" cr
     $cbfc 2@  $65021103. d= not ?exit
     ." C charset in use" cr ;

' .logo IS 'restart


\ *** Block No. 8, Hexblock 8

\   shell:                     03sep94pz

: dir  ( -- )
   dev 0 busopen  ascii $ bus! busoff
   dev 0 busin bus@ bus@ 2drop
   BEGIN cr bus@ bus@ 2drop
   i/o-status? 0= WHILE
   bus@ bus@ 256 * + u.
   BEGIN bus@ ?dup WHILE con! REPEAT
   REPEAT busoff dev 0 busclose ;

: dos  ( -- )
   bl word count ?dup
      IF  dev 15 busout  bustype
      busoff  cr ELSE drop THEN
   dev 15 busin
   BEGIN bus@ con! i/o-status? UNTIL
   busoff ;

: cat    ( -- )  cr
   dev 2 busopen  bl word count bustype
   busoff  dev 2 busin  BEGIN bus@ con!
   i/o-status? UNTIL busoff
   dev 2 busclose ;


\ *** Block No. 9, Hexblock 9

\   shell: cold' logo          14apr20pz

  : device  ( n -- )
     dev# c! ;

  : device?  ( -- )
     ." actual device number is "
     dev# c@ . ;

  : help  ( -- )
     ." available commands:" cr words ;

\\
| : init-shell  ( -- )
     only shell ;

' init-shell IS 'cold

| : .logo  ( -- )
     ."     running" cr
     ." peddi text editor V0.3" cr
     ." 1995 by Philip Zembrod" cr ;

' .logo IS 'restart


\ *** Block No. 10, Hexblock a

\ savesystem                   17apr20pz

\needs savesystem (

\needs savesysdev  | defer savesysdev
' dev IS savesysdev

' savesystem        alias saveall

\\ )

| : (savsys ( adr len -- )
 [ Assembler ] Next  [ Forth ]
 ['] pause  dup push  !  \ singletask
 i/o push  i/o off  bustype ;

  : saveall      \ name muss folgen
 save  dev 2 busopen  0 parse bustype
 " ,p,w" count bustype  busoff
 dev 2 busout  origin $17 -
 dup  $100 u/mod  swap bus! bus!
 here over - (savsys  busoff
 dev 2 busclose
 0 (drv ! derror? abort" save-error" ;


\ *** Block No. 11, Hexblock b

\ allocate compiler            28aug94pz

  ' linebuffer alias text[
  ' himem      alias ]text






















\ *** Block No. 12, Hexblock c

\ core loadscreen              14sep94pz

| : reset  ( -- )
     $0287 @ $fc00 and >r
     scr> $3ff and r@ or
     [ ' scr> >body ] literal !
     <scr $3ff and r@ or
     [ ' <scr >body ] literal !
     last-row> $3ff and r> or
     [ ' last-row> >body ] literal !

     text[ dup 1st-line> ! line> !
     char off  1.column off
     vir-char off
     #cr text[ c!  #cr ]text 1- c!
     text[ 1+ )text !
     ]text 1- text( ! ;


  1 3 +thru






\ *** Block No. 13, Hexblock d

\   edloop                     14sep94pz

\ 100 101 thru

| : edloop ( -- )
     create  64 0 DO ' , LOOP
    does> ( pfa -- )
     >r  end? off
     BEGIN key dup $60 and
        IF .char
        ELSE dup $1f and 2* swap $80
        and 2/ + r@ + @ execute THEN
\    check-mem
     end? @ UNTIL rdrop ;












\ *** Block No. 14, Hexblock e

\   edloop                     15sep94pz

| edloop edit-page

 .del-to  .bol     noop     quit-ed
 .del-under .eol   noop     noop
 noop     noop     noop     noop
 noop     .split-line noop  noop
 .del-line .down   noop     .screen
 .del-left noop    noop     savetext
 exit-ed  noop     noop     noop
 noop     .right   .del-from noop

 noop     noop     noop     noop
 noop     .20up    noop     noop
 .20down  noop     noop     noop
 noop     .cr      noop     noop
 noop     .up      noop     .kill-line
 .inst-line noop   noop     noop
 noop     noop     noop     noop
 noop     .left    noop     noop

 cr .( edit-page okay ! ) cr



\ *** Block No. 15, Hexblock f

\   ed                         14sep94pz

| : ed  ( -- )
     bl word filename /filename move
     filename c@ /filename 1- umin
     filename c!
     reset loadtext edit-page ;



















\ *** Block No. 16, Hexblock 10

                                2sep94pz

























\ *** Block No. 17, Hexblock 11

                               02sep94pz

























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


  1 26 +thru




\ *** Block No. 19, Hexblock 13

\   display                    02aug94pz

\needs code ascii @ word drop

Label (cbm>scr
 N 8 + sta $7F # and $20 # cmp
 CS ?[ $40 # cmp
    CS ?[ $1F # and  N 8 + bit
       0< ?[ $40 # ora  ]?  ]?  rts  ]?
 Ascii . # lda  rts

| Code cbm>scr  ( 8b1 -- 8b2 )
 SP X) lda  (cbm>scr jsr  SP X) sta
 Next jmp  end-code

\\ @

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
| 1024 constant scr>
| 1024 constant chr/scr
| 2024 constant <scr
| 1984 constant last-row>
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

| $d020 constant border
| : half  ( n - )
     border c! pause $80 0 DO LOOP ;

| : warn-signal ( -- )
     border push  0 half  1 half
                  0 half  1 half ;







\ *** Block No. 22, Hexblock 16

\   display                    02sep94pz
\\  \needs code  \\
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

\ *** Block No. 23, Hexblock 17

\   display                    02sep94pz

\needs >prevline (
\\ )

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
\\
| : >prevline ( line> -- line'> )
     dup  >prevline1
     swap (>prevline  over -
        IF warn-signal THEN ;
| : >nextline ( line> -- line'> )
     dup  >nextline1
     swap (>nextline  over -
        IF warn-signal THEN ;

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

\\

| : fold  ( -- )
     text( @  ]text 1- over -
     ?dup 0= IF drop exit THEN
     )text @ swap   dup )text +!
     cmove   ]text 1- text( ! ;








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














\ *** Block No. 45, Hexblock 2d

\   edit page                  20feb92pz

| : line-up ( -- )
     )text @ dup line> !
     text( @ under
     count under + 1+ text( !
     2+ 2dup + )text ! cmove ;

| : down ( -- )
     end-of-page? ?exit
     fold-line line-up .down ;

| : scrollup ( -- )
     end-of-page? ?exit
     fold-line line-up .scroll-up ;











\ *** Block No. 46, Hexblock 2e

\   edit page                  12apr92pz

| : delta-char ( -- n )
     line> @ 1+  char @  under
     -trailing nip - negate 2+ ;

| : len(rest) ( -- n )
     line> @ c@ char @ - ;

| : splitline ( -- )
     fold-line  2 mem? ?exit
     len(rest) >r  char>
     delta-char dup )text +! char +!
     char> r@ move
     r@ char> 1- c!  r> )text @ 1- c!
     char @ 2- dup  line> @ c!
     char> 1-  dup line> !  1- c!
     char off
     .del-from .down .inst-line
     1.column @
        IF 1.column off  .screen
        ELSE .cr .line THEN
     changed! ;



\ *** Block No. 47, Hexblock 2f

\   edit page                  12apr92pz

| : concatlines ( -- )
     begin-of-page? ?exit  fold-line
     line> @ dup c@ >r dup 1- c@
     dup char !  2+ negate line> +!
     1+ dup 2- r@ cmove
     r> char @ + dup
     )text @ 2- dup )text !  1- c!
     line> @ c!
     .del-line .up
     char @ 1.column @ - col/scr u<
        IF .line
        ELSE char @ col/scr 2/ -
        1.column !  .screen THEN
     changed! ;

| : delleft' ( -- )
     char @
        IF delleft
        ELSE concatlines THEN ;





\ *** Block No. 48, Hexblock 30

\   edit page                  12apr92pz

| : createline.after ( -- )
     text( @ 2- dup off text( ! ;

| : createline.before ( -- )
     line> @  dup  dup 2+  dup line> !
     )text @ 2+  dup )text !
     over - cmove>  off ;

| : instline ( -- )
     fold-line  2 mem? ?exit
     createline.before line-down
     .inst-line  changed! ;

| : nextline ( -- )
     fold-line  end-of-page?
        IF 2 mem? ?exit
        createline.after THEN
     line-up .down
     char off  1.column @
        IF 1.column off  .screen
        ELSE .cr THEN
     changed! ;


\ *** Block No. 49, Hexblock 31

\   edit page                  12apr92pz

| : clearline ( -- )
     line> @ dup off 2+ )text !
     .clear-line  changed! ;

| : delline ( -- )
     end-of-page?
        IF clearline
        ELSE fold-line
        line> @ )text !  line-up
        .del-line THEN
     changed! ;













\ *** Block No. 50, Hexblock 32

\   edit page: prototyp        19apr92pz

| : home-page ( -- )
     line> @ page[ @ =
        IF home-line
        ELSE unsplittext
        char off  1.column off
        page[ @ dup 1st-line> !
        dup line> !  count + 1+
        dup )text !  text( !
        splittext .screen THEN ;

| : end-page ( -- )
     text( @ ]page @ = blanklines @ 0=
    and IF home-line
        ELSE unsplittext
        char off  1.column off
        ]page @ dup text( ! dup )text !
        1- count - 2- dup line> !
        rows/scr 1- 0
        ?DO dup page[ @ = IF LEAVE THEN
        1- count - 2- LOOP 1st-line> !
        splittext .screen THEN ;



\ *** Block No. 51, Hexblock 33

k





          k





                    k





                              k







\ *** Block No. 52, Hexblock 34

\ features I                   15apr92pz

  1 8 +thru























\ *** Block No. 53, Hexblock 35

\   features I                 15apr92pz

| : insert-string ( adr +n )
     bounds ?DO I c@ putchar LOOP ;

| : del-string ( +n )
     0 DO delunder LOOP ;


\ : strncpy ( src dst maxlen -- )
\    rot count rot umin rot 2dup >r >r
\    1+ swap move r> r> c! ;

\    >r over c@ r> umin 2dup >r >r
\    1+ move r> r> swap c! ;

| : strcpy ( src dst -- )
     over c@ 1+ move ;

| : memcat
 ( dst dlen src slen -- dst dlen+slen )
     >r >r 2dup + r> swap r@ move
     r> + ;



\ *** Block No. 54, Hexblock 36

\   features I                 17apr92pz

| create (1msg 1 allot

| : .1charmsg ( c -- )
     (1msg c! (1msg 1 .msg ;


| : switch2text# ( n -- )
     unsplittext text#!
     text[ @ ]text @ =
     splittext  IF cleartext THEN
     .screen ;

| : switchtext ( -- )
     " goto text no. ?" count .msg
     key ascii 0 -
     dup 1 #texts uwithin
        IF dup switch2text#  ascii 0 +
        ELSE drop ascii ? THEN
     .1charmsg ;





\ *** Block No. 55, Hexblock 37

\   features I                 12apr92pz

| : linecpy ( src dst -- )
     over c@ 2+ move ;

| : (copyline ( -- )
     line> @ dup  c@ 2+ negate
     text( linestack> movetexts
     linestack> @ linecpy ;

| : copyline ( -- )
     257 mem? ?exit
     (copyline down ;

| : cutline ( -- )
     0 mem? ?exit
     (copyline delline ;









\ *** Block No. 56, Hexblock 38

\   features I                 12apr92pz

| : pasteline ( -- )
     linestack> @ charstack[ @ =
        IF warn-signal exit THEN
     0 mem? ?exit  instline
     linestack> @ dup c@ >r
     line> @ linecpy  r@ )text +!
     r> 2+ text( linestack> movetexts
     .line ;
















\ *** Block No. 57, Hexblock 39

\   features I                 16apr92pz

| 40 constant allot-unit

| : (copychar ( -- )
     charstack[ @ charstack> @ =
        IF allot-unit negate
        text( charstack[ movetexts THEN
     char @ line> @ c@ u<
        IF char> c@ ELSE bl THEN
     charstack> @ 1- dup charstack> !
     c! ;

| : copychar ( -- )
     allot-unit mem? ?exit
     (copychar right ;

| : cutchar ( -- )
     allot-unit mem? ?exit
     (copychar delunder ;






\ *** Block No. 58, Hexblock 3a

\   features I                 12apr92pz

| : pastechar ( -- )
     charstack> @ ]edit =
        IF warn-signal exit THEN
     1 mem? ?exit
     insert? push  insert? on
     charstack> @ dup 1+ charstack> !
     c@ putchar left
     charstack> @ charstack[ @ -
     charstack> @ ]edit xor
        IF allot-unit 2* u< 0=
        allot-unit and THEN
     ?dup
        IF text( charstack[ movetexts
        THEN ;










\ *** Block No. 59, Hexblock 3b

\   features I                 17apr92pz

| variable (cancel (cancel off
| : cancel ( -- )   (cancel on  end! ;
| : .cancel  " cancelled" count .msg ;
| : cancelled? ( -- flag )
     (cancel @  (cancel off
     dup IF .cancel THEN ;

| : strmemcat ( adr len str -- adr l' )
     count memcat ;

| : proceed? ( adr len -- flag )
     " proceed ? (y/n)" strmemcat .msg
     key ascii y = dup 0=
        IF .cancel THEN ;

| : unsaved? ( -- flag )
     changed? @ dup
        IF drop  pad 0
        " changes not saved! "
        strmemcat proceed? 0= THEN ;




\ *** Block No. 60, Hexblock 3c

\   features I                 18apr92pz

| : .logo ( -- )
     " peddi v1.0" count .msg ;

| : killtext ( -- )
     pad 0 " kill text: " strmemcat
     proceed?
        IF cleartext .logo .screen
        THEN ;
















\ *** Block No. 61, Hexblock 3d

\   features I                 17apr92pz

























\ *** Block No. 62, Hexblock 3e

\   features I                 12apr92pz

























\ *** Block No. 63, Hexblock 3f

\   features I                 12apr92pz

























\ *** Block No. 64, Hexblock 40

\   stuff                      12apr92pz

























\ *** Block No. 65, Hexblock 41

\   stuff                      12apr92pz

























\ *** Block No. 66, Hexblock 42

\   stuff                      12apr92pz

























\ *** Block No. 67, Hexblock 43

\   stuff                      12apr92pz

























\ *** Block No. 68, Hexblock 44

k





          k





                    k





                              k







\ *** Block No. 69, Hexblock 45

k





          k





                    k





                              k







\ *** Block No. 70, Hexblock 46

k





          k





                    k





                              k







\ *** Block No. 71, Hexblock 47

k





          k





                    k





                              k







\ *** Block No. 72, Hexblock 48

\ features II                  19apr92pz

 1 12 +thru























\ *** Block No. 73, Hexblock 49

\   features II                15apr92pz

| edloop edit-line

 copychar noop     noop     noop
 delunder noop     noop     noop
 noop     noop     noop     noop
 noop     end!     noop     noop
 noop     noop     noop     noop
 delleft  noop     noop     noop
 noop     noop     noop     noop
 noop     right    noop     noop

 noop     noop     noop     noop
 noop     noop     noop      pastechar
 noop     noop     noop     cutchar
 noop     cancel   noop     noop
 noop     noop     noop     noop
 +-inst   noop     noop     noop
 noop     noop     noop     noop
 noop     left     noop     noop

 cr .( edit-line okay ! ) cr



\ *** Block No. 74, Hexblock 4a

\   features II                12apr92pz

| : edit-string ( adr maxlen -- )
     2nd-screen  text#@ >r
     unsplittext 0 text#! splittext
     .screen over count insert-string
     edit-line
     line> @ count rot umin rot 2dup c!
     1+ swap cmove  cleartext
     unsplittext r> text#! splittext
     1st-screen ;















\ *** Block No. 75, Hexblock 4b

\   features II                17apr92pz

| : cr=    c@   $0d = ;
| : lf=    c@   $0a = ;
| : crlf=   @ $0a0d = ; \ lo/hi-Byte im
| : lfcr=   @ $0d0a = ; \ Intel-Format

| create eol-cfa
   ' cr= , ' lf= , ' crlf= , ' lfcr= ,
| create eol-seq
   $0d ,  $0a ,  $0a0d ,  $0d0a ,
| create eol-len
   1 c, 1 c, 2 c, 2 c,
| create eol-name
   ," cr" ," lf"
   ," crlf" ," lfcr"

| defer eol=
| variable eol
| variable /eol






\ *** Block No. 76, Hexblock 4c

\   features II                17apr92pz

| variable eol#  eol# off

| : .eol-name ( -- )
     pad 0 " eol:" strmemcat
     eol-name  eol# @ 3 and  0
     ?DO count + LOOP strmemcat .msg ;

| : set-eol ( -- )
     eol# @ 3 and
        dup eol-len + c@ /eol !
     2* dup eol-cfa + @ IS eol=
            eol-seq + @ eol ! ;

| : switch-eol ( -- )
     1 eol# +!  set-eol  .eol-name ;









\ *** Block No. 77, Hexblock 4d

\   features II                12apr92pz

| : chr, ( adr c -- adr+1 )
     over c! 1+ ;

| : break-line ( n1 n2 -- n3 n4 )
     under over - 1-
     under swap c!  chr, dup 1+ ;

( /???/...ascii-text.../
    ^ - n1              ^ - n2
              ---
  /len/...ascii-text.../len/???/
                        n3 - ^  ^ - n4 )












\ *** Block No. 78, Hexblock 4e

\   features II                12apr92pz

| : ascii>list ( -- )
     page[ @ )text @ 2dup ]page @
     swap - + >r  over - r@ swap cmove>
     page[ @ dup 1+
     ]page @ /eol @ - 1+ r>
     DO I eol=
        IF break-line  /eol @
        ELSE 2dup - -255 <
           IF break-line  /eol @
           " split long line" count .msg
           ELSE I c@ chr,  1 THEN THEN
     +LOOP
     2dup 1- - IF break-line THEN drop
     dup )text ! 1- count - 2-
     dup line> !  1st-line> !
     char off  ]page @ text( ! ;








\ *** Block No. 79, Hexblock 4f

\   features II                17apr92pz

| : (.filename ( str -- )
     pad 0 rot strmemcat
     "  filename ?" strmemcat .msg ;

| : getfilename  ( str -- name )
     (.filename
     filename pad strcpy
     pad /filename edit-string
     dup c@ 0=  cancelled?  or
        IF rdrop exit THEN
     filename c@ 0=
        IF pad filename strcpy THEN
     pad ;

| : renamefile  ( -- )
     " new" (.filename
     filename /filename edit-string ;







\ *** Block No. 80, Hexblock 50

\   features II                19apr92pz

| ascii , constant ','

| : checktypespec ( adr l -- adr' l' )
     ?dup IF over 1+ c@ ascii @ u>
             IF $ffff0001. d+ ',' scan
             THEN THEN ;

| : setlength ( str x l -- str x l )
     2 pick c@ over - 3 pick c! ;

| : scanfilename
    ( name[,ga[,sa]] -- name ga sa )
     dup count  2dup + 0 swap c!
     ',' scan  checktypespec  setlength
     0= IF drop 8 2 exit THEN
     0 0 rot convert nip
     dup c@ ',' -
        IF drop 2 exit THEN
     0 0 rot convert 2drop ;





\ *** Block No. 81, Hexblock 51

\   features II                19apr92pz

| 2variable faddr

| : derror? ( -- flag )
     2nd-screen .cls
     faddr 2@ drop 15 busin
     bus@ dup ascii 0 - swap
     BEGIN .char bus@ i/o-status? UNTIL
     drop busoff 1st-screen ;

| : fileopen ( name ga sa r/w -- )
     >r
     busopen count 2dup bustype
     + 2- c@ ',' -
        IF ',' bus! ascii s bus! THEN
     ',' bus! r> bus! busoff ;









\ *** Block No. 82, Hexblock 52

\   features II                18apr92pz

| : readascii ( name -- )
     cleartext
     scanfilename 2dup faddr 2!
     busopen count bustype
     " ,s,r" count bustype busoff
     derror? ?exit
     faddr 2@ busin
     page[ @ ]page @ over - min.free -
     busread
        IF )text !
        ELSE ]text @ min.free - )text !
        " memory full" count .msg THEN
     busoff  faddr 2@ busclose
     derror? drop ;

| : readtext ( -- )
     unsaved? ?exit
     " read:" getfilename readascii
     ascii>list  changed? off
     home-page ;




\ *** Block No. 83, Hexblock 53

\   features II                12apr92pz

| : backup-file ( ga name -- )
     over 15 busout
     " s0:/" count bustype
     dup count bustype busoff
     swap 15 busout
     " r0:/" count bustype
     dup count bustype ascii = bus!
     count bustype busoff ;
















\ *** Block No. 84, Hexblock 54

\   features II                17apr92pz

| : writetext ( -- )
     " write:" getfilename scanfilename
     2dup faddr 2!
     over 3 pick backup-file
     busopen count bustype
     " ,s,w" count bustype busoff
     derror? ?exit
     faddr 2@ busout
     page[ @ BEGIN dup count bustype
             eol c@ bus!  /eol @ 1-
                IF eol 1+ c@ bus! THEN
             >nextline dup ]page @ =
             UNTIL
     busoff  faddr 2@ busclose
     derror? drop  changed? off ;









\ *** Block No. 85, Hexblock 55

\   frame                      12apr92pz

| edloop edit-page

 copychar noop     noop     noop
 delunder readtext noop     noop
 noop     noop     noop     noop
 noop     splitline noop    noop
 noop     down     noop     noop
 delleft' noop     noop     noop
 end!     noop     noop     noop
 noop     right    copyline noop

 noop     noop     noop     noop
 noop     instline pasteline pastechar
 scrollup delline  cutline  cutchar
 scrolldown nextline noop   noop
 writetext up      switch-eol clearline
 +-inst   noop     noop     noop
 noop     noop     noop     noop
 noop     left     noop     renamefile

 cr .( edit-page okay ! ) cr



\ *** Block No. 86, Hexblock 56

\   frame                      01may92pz

























\ *** Block No. 87, Hexblock 57

k





          k





                    k





                              k







\ *** Block No. 88, Hexblock 58

k





          k





                    k





                              k







\ *** Block No. 89, Hexblock 59

k





          k





                    k





                              k







\ *** Block No. 90, Hexblock 5a

\ allocate                     01may92pz

  1 1 +thru























\ *** Block No. 91, Hexblock 5b

\   allocate                   01may92pz

\ ultraFORTH-specific definition:

| 2048 constant stacksize
| : heapspace ( -- n )
     s0 @  here -  stacksize umax
     stacksize - ;

| variable (edit[
| variable (]edit
| : edit[  (edit[ @ ;
| : ]edit  (]edit @ ;

| : edit[]-allocate ( -- n )
     heap (]edit !
     heapspace dup hallot
     heap (edit[ ! ;

| : edit[]-free ( -- )
     heap edit[ =
        IF edit[ ]edit - hallot ELSE
        ." editor can't release memory"
        THEN ;


\ *** Block No. 92, Hexblock 5c

k





          k





                    k





                              k







\ *** Block No. 93, Hexblock 5d

k





          k





                    k





                              k







\ *** Block No. 94, Hexblock 5e

k





          k





                    k





                              k







\ *** Block No. 95, Hexblock 5f

k





          k





                    k





                              k







\ *** Block No. 96, Hexblock 60

\ frame                        01may92pz

 1 3 +thru























\ *** Block No. 97, Hexblock 61

\   frame                      18apr92pz

| edloop edit-page

 copychar noop     scrolldown noop
 delunder writetext noop    noop
 noop     noop     noop     killtext
 noop     splitline scrollup home-line
 end-line down     noop     home-page
 delleft' noop     noop     noop
 end!     noop     noop     noop
 renamefile right  copyline switchtext

 noop     noop     noop     noop
 noop     instline pasteline pastechar
 htab>    delline  cutline  cutchar
 <htab    nextline clearline noop
 readtext up       switch-eol end-page
 +-inst   noop     noop     noop
 noop     noop     noop     noop
 noop     left     noop     noop

 cr .( edit-page okay ! ) cr



\ *** Block No. 98, Hexblock 62

\   frame                      01may92pz

| variable any-changed?

| : show-unsaved ( -- )
     any-changed? off  text#@  pad 0
     " unsaved texts: " strmemcat
     #texts 1 DO I text#!  changed? @
        IF I [ ascii 0  bl 256 * + ]
        literal + over 3 pick + !  2+
        any-changed? on THEN
     LOOP
     any-changed? @
        IF 1- .msg ELSE 2drop THEN
     text#! ;











\ *** Block No. 99, Hexblock 63

\   frame                      01may92pz

| : peddi ( -- )
     edit[]-allocate  1000 u< IF
     ." too little memory for editor"
     exit THEN

     init-mem  init-display  set-eol
     1 switch2text#  .logo

     BEGIN edit-page show-unsaved
     " exit? (y/n)" count .msg
     key ascii y =
        dup 0= IF .cancel THEN
     UNTIL

     page edit[]-free ;









\ *** Block No. 100, Hexblock 64

\ check-mem                    13sep94pz

  : check-mem  ( -- )
     line> @ 1st-line> @ last-line> @
     1+ uwithin not
        IF warn-signal 1 1060 c! THEN
\    )text @ 1st-line> @ last-line> @
\    1+ uwithin not
\       IF warn-signal 2 1061 c! THEN
\    text( @ 1st-line> @ last-line> @
\    1+ uwithin not
\       IF warn-signal 3 1062 c! THEN
     1st-line> @   24 blanklines @ DO
     >nextline LOOP last-line> @ = 0=
        IF warn-signal 4 1063 c! THEN
     )text @ line> @ text( @
     uwithin not
        IF warn-signal 5 1059 c! THEN
     line> @ >nextline text( @ -
        IF warn-signal 6 1058 c! THEN
  ;





\ *** Block No. 101, Hexblock 65

\                              14sep94pz

| : pr-mem  ( -- )
   page ." text[ " text[ u. cr
   ." 1st-line> " 1st-line> @ u. cr
   ." line> " line> @ u. cr
   ." char> " char>   u. cr
   ." )text " )text @ u. cr
   ." text( " text( @ u. cr
   ." last-line> " last-line> @ u. cr
   ." ]text " ]text u. cr
   ." blanklines " blanklines @ u. cr
   1st-line> @   24 blanklines @ DO
   dup u. ?cr >nextline LOOP u. cr ;












\ *** Block No. 102, Hexblock 66

\                              14sep94pz

| : .inst-line ( -- )
     vir-char off   1 mem? ?exit
     line> @  )text @ over - >r
     text( @ r@ -  dup text( !
     r> cmove>
     )text @ dup line> !  #cr over c!
     1+ )text !     last-line-up
     flip  csr.row> @ (inst-line
     flip  .vir-left ;

           IF .up THEN
        csr.row> @ (del-line
        col/scr negate csr.row> +!
        blanklines @ 0=
           IF last-line> @ last-row>
           (.line THEN








\ *** Block No. 103, Hexblock 67

                               14sep94pz

























\ *** Block No. 104, Hexblock 68

k





          k





                    k





                              k







\ *** Block No. 105, Hexblock 69

k





          k





                    k





                              k







\ *** Block No. 106, Hexblock 6a

k





          k





                    k





                              k







\ *** Block No. 107, Hexblock 6b

k





          k





                    k





                              k







\ *** Block No. 108, Hexblock 6c

k





          k





                    k





                              k







\ *** Block No. 109, Hexblock 6d

k





          k





                    k





                              k







\ *** Block No. 110, Hexblock 6e

k





          k





                    k





                              k







\ *** Block No. 111, Hexblock 6f

k





          k





                    k





                              k







\ *** Block No. 112, Hexblock 70

k





          k





                    k





                              k







\ *** Block No. 113, Hexblock 71

k





          k





                    k





                              k







\ *** Block No. 114, Hexblock 72

k





          k





                    k





                              k







\ *** Block No. 115, Hexblock 73

k





          k





                    k





                              k







\ *** Block No. 116, Hexblock 74

k





          k





                    k





                              k







\ *** Block No. 117, Hexblock 75

k





          k





                    k





                              k







\ *** Block No. 118, Hexblock 76

k





          k





                    k





                              k







\ *** Block No. 119, Hexblock 77

k





          k





                    k





                              k







\ *** Block No. 120, Hexblock 78

\ transient Assembler         c09may94pz

\needs code  1 +load























\ *** Block No. 121, Hexblock 79

\ Forth-6502 Assembler        c18jun94pz

\ Basis: Forth Dimensions VOL III No. 5)

\ internal loading         04may85BP/re)

here   $800 hallot  heap dp !

Onlyforth  Assembler also definitions
         1 7 +thru


' noop Is .status

: .blk  ( -)
 blk @ ?dup IF  ."  Blk " u. ?cr  THEN ;

' .blk Is .status


dp !

Onlyforth



\ *** Block No. 122, Hexblock 7a

\ Forth-83 6502-Assembler      20oct87re

: end-code   context 2- @  context ! ;

Create index
$0909 , $1505 , $0115 , $8011 ,
$8009 , $1D0D , $8019 , $8080 ,
$0080 , $1404 , $8014 , $8080 ,
$8080 , $1C0C , $801C , $2C80 ,

| Variable mode

: Mode:  ( n -)   Create c,
  Does>  ( -)     c@ mode ! ;

0   Mode: .A        1    Mode: #
2 | Mode: mem       3    Mode: ,X
4   Mode: ,Y        5    Mode: X)
6   Mode: )Y       $F    Mode: )







\ *** Block No. 123, Hexblock 7b

\ upmode  cpu                  20oct87re

| : upmode ( addr0 f0 - addr1 f1)
 IF mode @  8 or mode !   THEN
 1 mode @  $F and ?dup IF
 0 DO  dup +  LOOP THEN
 over 1+ @ and 0= ;

: cpu  ( 8b -)   Create  c,
  Does>  ( -)    c@ c, mem ;

 00 cpu brk $18 cpu clc $D8 cpu cld
$58 cpu cli $B8 cpu clv $CA cpu dex
$88 cpu dey $E8 cpu inx $C8 cpu iny
$EA cpu nop $48 cpu pha $08 cpu php
$68 cpu pla $28 cpu plp $40 cpu rti
$60 cpu rts $38 cpu sec $F8 cpu sed
$78 cpu sei $AA cpu tax $A8 cpu tay
$BA cpu tsx $8A cpu txa $9A cpu txs
$98 cpu tya






\ *** Block No. 124, Hexblock 7c

\ m/cpu                        20oct87re

: m/cpu  ( mode opcode -)  Create c, ,
 Does>
 dup 1+ @ $80 and IF $10 mode +! THEN
 over $FF00 and upmode upmode
 IF mem true Abort" invalid" THEN
 c@ mode @ index + c@ + c, mode @ 7 and
 IF mode @  $F and 7 <
  IF c, ELSE , THEN THEN mem ;

$1C6E $60 m/cpu adc $1C6E $20 m/cpu and
$1C6E $C0 m/cpu cmp $1C6E $40 m/cpu eor
$1C6E $A0 m/cpu lda $1C6E $00 m/cpu ora
$1C6E $E0 m/cpu sbc $1C6C $80 m/cpu sta
$0D0D $01 m/cpu asl $0C0C $C1 m/cpu dec
$0C0C $E1 m/cpu inc $0D0D $41 m/cpu lsr
$0D0D $21 m/cpu rol $0D0D $61 m/cpu ror
$0414 $81 m/cpu stx $0486 $E0 m/cpu cpx
$0486 $C0 m/cpu cpy $1496 $A2 m/cpu ldx
$0C8E $A0 m/cpu ldy $048C $80 m/cpu sty
$0480 $14 m/cpu jsr $8480 $40 m/cpu jmp
$0484 $20 m/cpu bit



\ *** Block No. 125, Hexblock 7d

\ Assembler conditionals       20oct87re

| : range?   ( branch -- branch )
 dup abs  $7F u> Abort" out of range " ;

: [[  ( BEGIN)  here ;

: ?]  ( UNTIL)  c, here 1+ - range? c, ;

: ?[  ( IF)     c,  here 0 c, ;

: ?[[ ( WHILE)  ?[ swap ;

: ]?  ( THEN)   here over c@  IF swap !
 ELSE over 1+ - range? swap c! THEN ;

: ][  ( ELSE)   here 1+   1 jmp
 swap here over 1+ - range?  swap c! ;

: ]]  ( AGAIN)  jmp ;

: ]]? ( REPEAT) jmp ]? ;




\ *** Block No. 126, Hexblock 7e

\ Assembler conditionals       20oct87re

$90 Constant CS     $B0 Constant CC
$D0 Constant 0=     $F0 Constant 0<>
$10 Constant 0<     $30 Constant 0>=
$50 Constant VS     $70 Constant VC

: not    $20 [ Forth ] xor ;

: beq    0<> ?] ;   : bmi   0>= ?] ;
: bne    0=  ?] ;   : bpl   0<  ?] ;
: bcc    CS  ?] ;   : bvc   VS  ?] ;
: bcs    CC  ?] ;   : bvs   VC  ?] ;













\ *** Block No. 127, Hexblock 7f

\ 2inc/2dec   winc/wdec        20oct87re

: 2inc  ( adr -- )
 dup lda  clc  2 # adc
 dup sta  CS ?[  swap 1+ inc  ]?  ;

: 2dec  ( adr -- )
 dup lda  sec  2 # sbc
 dup sta  CC ?[  swap 1+ dec  ]?  ;

: winc  ( adr -- )
 dup inc  0= ?[  swap 1+ inc  ]?  ;

: wdec  ( adr -- )
 dup lda  0= ?[  over 1+ dec  ]?  dec  ;

: ;c:
 recover jsr  end-code ]  0 last !  0 ;








\ *** Block No. 128, Hexblock 80

\ ;code Code code>          bp/re03feb85

Onlyforth

: Assembler
 Assembler   [ Assembler ] mem ;

: ;Code
 [compile] Does>  -3 allot
 [compile] ;      -2 allot   Assembler ;
immediate

: Code  Create here dup 2- ! Assembler ;

: >label  ( adr -)
 here | Create  immediate  swap ,
 4 hallot heap 1 and hallot ( 6502-alig)
 here 4 - heap  4  cmove
 heap last @ count $1F and + !  dp !
  Does>  ( - adr)   @
  state @ IF  [compile] Literal  THEN ;

: Label
 [ Assembler ]  here >label Assembler ;


\ *** Block No. 129, Hexblock 81

k





          k





                    k





                              k







\ *** Block No. 130, Hexblock 82

k





          k





                    k





                              k







\ *** Block No. 131, Hexblock 83

k





          k





                    k





                              k







\ *** Block No. 132, Hexblock 84

k





          k





                    k





                              k







\ *** Block No. 133, Hexblock 85

k





          k





                    k





                              k







\ *** Block No. 134, Hexblock 86

k





          k





                    k





                              k







\ *** Block No. 135, Hexblock 87

k





          k





                    k





                              k







\ *** Block No. 136, Hexblock 88

k





          k





                    k





                              k







\ *** Block No. 137, Hexblock 89

k





          k





                    k





                              k







\ *** Block No. 138, Hexblock 8a

k





          k





                    k





                              k







\ *** Block No. 139, Hexblock 8b

k





          k





                    k





                              k







\ *** Block No. 140, Hexblock 8c

k





          k





                    k





                              k







\ *** Block No. 141, Hexblock 8d

k





          k





                    k





                              k







\ *** Block No. 142, Hexblock 8e

k





          k





                    k





                              k







\ *** Block No. 143, Hexblock 8f

k





          k





                    k





                              k







\ *** Block No. 144, Hexblock 90

k





          k





                    k





                              k







\ *** Block No. 145, Hexblock 91

k





          k





                    k





                              k







\ *** Block No. 146, Hexblock 92

k





          k





                    k





                              k







\ *** Block No. 147, Hexblock 93

k





          k





                    k





                              k







\ *** Block No. 148, Hexblock 94

k





          k





                    k





                              k







\ *** Block No. 149, Hexblock 95

k





          k





                    k





                              k







\ *** Block No. 150, Hexblock 96

\ test-include                 10sep94pz

: o1 8 2 busopen " io.c,s,r" count
  bustype busoff ;

: o2 8 3 busopen " baselib.h,s,r" count
  bustype busoff ;

: c1 8 2 busclose ;
: c2 8 3 busclose ;

: t1  8 2 busin 0 ?DO bus@ con! LOOP
      busoff ;

: t2  8 3 busin 0 ?DO bus@ con! LOOP
      busoff ;










\ *** Block No. 151, Hexblock 97

k





          k





                    k





                              k







\ *** Block No. 152, Hexblock 98

k





          k





                    k





                              k







\ *** Block No. 153, Hexblock 99

k





          k





                    k





                              k







\ *** Block No. 154, Hexblock 9a

k





          k





                    k





                              k







\ *** Block No. 155, Hexblock 9b

k





          k





                    k





                              k







\ *** Block No. 156, Hexblock 9c

k





          k





                    k





                              k







\ *** Block No. 157, Hexblock 9d

k





          k





                    k





                              k







\ *** Block No. 158, Hexblock 9e

k





          k





                    k





                              k







\ *** Block No. 159, Hexblock 9f

k





          k





                    k





                              k







\ *** Block No. 160, Hexblock a0

k





          k





                    k





                              k







\ *** Block No. 161, Hexblock a1

k





          k





                    k





                              k







\ *** Block No. 162, Hexblock a2

k





          k





                    k





                              k







\ *** Block No. 163, Hexblock a3

k





          k





                    k





                              k







\ *** Block No. 164, Hexblock a4

k





          k





                    k





                              k







\ *** Block No. 165, Hexblock a5

k





          k





                    k





                              k







\ *** Block No. 166, Hexblock a6

k





          k





                    k





                              k







\ *** Block No. 167, Hexblock a7

k





          k





                    k





                              k







\ *** Block No. 168, Hexblock a8

k





          k





                    k





                              k







\ *** Block No. 169, Hexblock a9

k





          k





                    k





                              k






