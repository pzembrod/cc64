\ *** Block No. 30, Hexblock 1e

\ input: loadscreen            20sep94pz

\ terminology / interface:

\ nextline
\ open-input    close-input
\ open-include  close-include
\ char>         +char
\ line          res-inptr
\ comment-line  comment-state
\ #eof
\ source-name
\ printcontext

\ *** Block No. 31, Hexblock 1f

\   input :  variable          14sep94pz

|| 4 constant max-level
|| variable include-level
|| create name[]
          /filename max-level * allot
|| create line[]    max-level 2* allot
|| create filepos[] max-level 2* allot

~ variable comment-state
~ variable comment-line
| variable eof

~ doer preprocess

|| variable inptr

~ : +char  ( -- )  1 inptr +! ;
~ : char>  ( -- c )  inptr @ c@ ;
\ : char>  ( -- c )   eof @
\    IF #eof ELSE inptr @ c@ THEN ;

~ : res-inptr  linebuf inptr ! ;


\ *** Block No. 32, Hexblock 20

\   input: open/close-input    11sep94pz

~ : source-name     include-level @
                 /filename * name[] + ;
~ : line  include-level @ 2* line[] + ;
| : filepos         include-level @
                       2* filepos[] + ;

~ : close-input ( -- )
     comment-state @
        IF *comment* error
        comment-line @ u.
        " */" linebuf strcpy
        ELSE linebuf off THEN
     source-file fclose ;

|| : open-source  ( -- )
     ascii r ascii s source-name
     source-file fopen  res-inptr ;

~ : open-input ( name -- )
     source-name strcpy
     eof off  comment-state off
     line off  linebuf off  filepos off
     open-source ;


\ *** Block No. 33, Hexblock 21

\   input: open/close-include  11sep94pz

~ : close-include ( -- )
     close-input
     include-level @
        IF -1 include-level +!
        ." end of include file" cr
        reopen-outfiles  open-source
        source-file fsetin
        filepos @ fskip  funset
        ELSE ." end of source file" cr
        #eof eof ! THEN ;

~ : open-include  ( name -- )
     ." include-file: "
     dup count type cr
     include-level @ 1+ dup max-level u<
        IF include-level !
        source-file fclose
        reopen-outfiles  open-input
        ELSE *inc-nest* error  2drop
        THEN ;


\ *** Block No. 34, Hexblock 22

\   input :  nextline           14sep94pz

~ variable listing  listing on

|| : printsourceline  ( -- )
     linebuf /linebuf bounds
     DO I c@ ?dup 0= IF LEAVE THEN
     emit LOOP cr ;

~ : nextline ( -- )
     source-file feof?
        IF close-include
        eof @ ?exit THEN
     1 line +!
     source-file fsetin
     linebuf /linebuf 1- #cr fget2delim
        *longline* ?error
     dup filepos +!
     1- /linebuf 1- umin
     linebuf + 0 swap c!
     funset
     listing @ IF line @ u.
            ." : " printsourceline THEN
     res-inptr  preprocess ;


\ *** Block No. 35, Hexblock 23

\   input :  printcontext      11sep94pz

make printcontext  ( -- )
      context? @ 0= ?exit
      linebuf c@ 0= ?exit
      printsourceline
      inptr @ linebuf - 1- 0 max
      spaces ASCII ^ emit  cr ;

|| : init-input ( -- )
     include-level off
     linebuf off  res-inptr
     context? on ;
    init: init-input

\ context? is defined in errorhandler
\ and shall avoid context printing
\ if an error occurs during init while
\ no valid linebuf content exists.
