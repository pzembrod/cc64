
\ input.fth - handling of C source input

\ terminology / interface:

\ char>  +char  clearline  main-eof
\ nextline
\ open-input
\ open-include
\ comment-starts comment-state
\ source-name
\ printcontext


\ Variables per level of nested include file

|| 4 constant max-level
|| variable include-level
|| create name[]
          /filename max-level * allot
|| create line#[]   max-level cells allot
|| create filepos[] max-level cells allot

~ : source-name     include-level @
                 /filename * name[] + ;
~ : line#  include-level @ 2* line#[] + ;
| : filepos         include-level @
                       2* filepos[] + ;

\ Handling of current char

|  variable main-eof
|| variable inptr

~  : +char  ( -- )  1 inptr +! ;
~  : char>  ( -- c )  inptr @ c@ ;
~  : clearline ( -- )  linebuf  dup off  inptr ! ;


\ Keeping track of whether and where a comment started

~  variable comment-state
|| variable comment-line#
| : comment-starts  ( -- )  line# @ comment-line# ! ;

\ Opening and closing of source and include files

~ : close-input ( -- )
     comment-state @
        IF *comment* error
        comment-line# @ u.
        " */" linebuf strcpy
        ELSE linebuf off THEN
     source-file fclose ;

|| : (re-)open-source  ( -- )
     ascii r ascii s source-name
     source-file fopen  clearline ;

~ : open-input ( name -- )
     source-name strcpy
     main-eof off  comment-state off
     line# off  filepos off
     (re-)open-source ;

~ : close-include ( -- )
     close-input
     include-level @
        IF -1 include-level +!
        ." end of include file" cr
        reopen-outfiles  (re-)open-source
        source-file fsetin
        filepos @ fskip  funset
        ELSE ." end of source file" cr
        main-eof on THEN ;

~ : open-include  ( name -- )
     ." include-file: "
     dup count type cr
     include-level @ 1+ dup max-level u<
        IF include-level !
        source-file fclose
        reopen-outfiles  open-input
        ELSE *inc-nest* error  2drop
        THEN ;

\ Handling of current line

~ doer preprocess

~ variable listing  listing off

|| : printsourceline  ( -- )
     linebuf /linebuf bounds
     DO I c@ ?dup 0= IF LEAVE THEN
     emit LOOP cr ;

~ : nextline ( -- )
     source-file feof?
        IF close-include
        main-eof @ ?exit THEN
     1 line# +!  clearline
     source-file fsetin
     linebuf /linebuf 1- #cr fget2delim
        *longline* ?error
     dup filepos +!
     1- /linebuf 1- umin
     linebuf + 0 swap c!
     funset
     listing @ IF line# @ u.
            ." : " printsourceline THEN
     preprocess ;

\ Providing context for error messages

make printcontext  ( -- )
      context? @ 0= ?exit
      linebuf c@ 0= ?exit
      printsourceline
      inptr @ linebuf - 1- 0 max
      spaces ASCII ^ emit  cr ;

\ context? is defined in errorhandler
\ and shall avoid context printing
\ if an error occurs during init while
\ no valid linebuf content exists.

|| : init-input ( -- )
     include-level off
     clearline
     context? on ;
    init: init-input
