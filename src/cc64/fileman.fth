\ *** Block No. 78, Hexblock 4e

\ fileman: loadscreen          20sep94pz

\prof profiler-bucket [fileman]

\ terminology / interface:

\ source-file
\ code-file       code-name
\ static-file     static-name

\ /filename
\ dev             dev#

\ close-files     scratch-all
\ scratch-outs    scratch-tmps
\ open-outfiles   close-outfiles
\ reopen-outfiles

\ init-files


\ *** Block No. 79, Hexblock 4f

\   fileman:                   20sep94pz

~ fhandle source-file
~ fhandle code-file
~ fhandle static-file
~ fhandle exe-file

~ 17 constant /filename
~ create exe-name   /filename allot

~ create code-name    ," %%code"
~ create static-name  ," %%init"

~ create dev#  8 c,
~ : dev   ( -- dev )  dev# c@ ;
~ create aux#  8 c,
~ : aux   ( -- aux )  aux# c@ ;

~ : init-files
     dev 2 source-file  set-fhandle
     aux 3 code-file    set-fhandle
     aux 4 static-file  set-fhandle
     dev 5 exe-file     set-fhandle ;

    init: init-files


\ *** Block No. 80, Hexblock 50

\   fileman:                   11sep94pz

| : loadadr!  ( handle -- )
     fsetout 0 fputc 64 fputc funset ;

~ : open-outfiles  ( -- )
     ascii w ascii p code-name
     code-file fopen
     code-file loadadr!
     ascii w ascii p static-name
     static-file fopen
     static-file loadadr! ;

~ : close-outfiles  ( -- )
     code-file   fclose
     static-file fclose ;

~ : reopen-outfiles  ( -- )
     close-outfiles
     ascii a ascii p code-name
     code-file fopen
     ascii a ascii p static-name
     static-file fopen ;


\ *** Block No. 81, Hexblock 51

\   fileman:                   13apr20pz

~ create code.suffix ," .o"
~ create init.suffix ," .i"
~ create decl.suffix ," .h"
~ : cut-suffix  ( str -- )
     dup c@ 2- swap c! ;

|| : s!  ( str -- )  count bustype ;
|| : s0:!  ( -- )  dev 15 busout " s0:" s! ;
|| : scratch1  ( fname -- )
     s0:!  s!  busoff ;
|| : scratch2  ( fname-part2 fname-part1 -- )
     s0:!  s! s!  busoff ;

~ : scratch-outs  ( -- )
     dev 15 busout " s0:" s!
                 exe-name scratch1
     code.suffix exe-name scratch2
     init.suffix exe-name scratch2
     decl.suffix exe-name scratch2 ;

~ : scratch-tmps ( -- )
  ." scratching temporary files" cr
     code-name   scratch1
     static-name scratch1 ;

make close-files  ( -- )
      source-file  fclose
      exe-file     fclose
      close-outfiles ;

make scratch-all ( -- )
  scratch-tmps  scratch-outs ;

\prof [fileman] end-bucket
