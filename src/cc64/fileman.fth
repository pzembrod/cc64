\ *** Block No. 78, Hexblock 4e

\ fileman: loadscreen          20sep94pz

\ terminology / interface:

\ source-file
\ code-file       code-name
\ static-file     static-name

\ /filename
\ dev             dev#

\ close-files     scratchfiles
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

  create dev#  8 c,
  : dev   ( -- dev )  dev# c@ ;
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

make close-files  ( -- )
      source-file  fclose
      exe-file     fclose
      close-outfiles ;

make scratchfiles ( -- )
  ." scratching temporary files" cr
  dev 15 busout
  " s0:%%code" count bustype busoff
  dev 15 busout
  " s0:%%init" count bustype busoff ;
