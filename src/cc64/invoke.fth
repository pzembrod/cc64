\ *** Block No. 100, Hexblock 64

\ invoke :  loadscreen         21sep94pz

\ *** Block No. 101, Hexblock 65

\   invoke :  pass1            11sep94pz

|| : pass1 ( -- )
     open-outfiles
     ." source file: "
     source-name count type cr
     source-name open-input
     compile-program
     end-of-code close-outfiles ;

|| : ?usage  ( flag -- )
     IF ." usage: cc file.c" cr
     rdrop THEN ;


\ *** Block No. 102, Hexblock 66

\   invoke :  start compiler   11sep94pz

|| : wait-scratch  ( -- )
     dev 15 busin BEGIN bus@ drop
     i/o-status? UNTIL busoff ;

|| : s!  count bustype ;
|| : ,!  ascii , bus! ;

|| : scratch-exe  ( -- )
     dev 15 busout " s0:" s!
     exe-name s!        ,!
     exe-name s! code.suffix s! ,!
     exe-name s! init.suffix s! ,!
     exe-name s! decl.suffix s!
     busoff
     wait-scratch ;


\ *** Block No. 103, Hexblock 67

\   invoke :  start compiler   13sep94pz

\ forth definitions

  : cc  ( -- )
     clearstack
     \prof profiler-start
     \prof read-50ms-timer
     init
     bl word   dup c@ 0= ?usage
     dup exe-name strcpy
         source-name strcpy
     exe-name count 2-
     dup exe-name c!  + @
    [ ascii . ascii c 256 * + ] literal
     -  ?usage
     scratch-exe
     cr cr ." pass 1:" cr
     pass1  cr
     any-errors? @
        IF ." error(s) occured" cr
        close-files scratchfiles exit
        THEN
     \prof dup read-50ms-timer - ms. cr
     ." pass 2:" cr
     pass2  cr
     ." compilation done" cr
     scratchfiles
     \prof read-50ms-timer - ms. cr
     \prof profiler-end
     ;
