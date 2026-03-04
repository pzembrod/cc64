
\ invoke

|| : compile-source ( -- )
     open-outfiles
     ." source file: "
     source-name count type cr
     source-name open-input
     compile-program
     end-of-code close-outfiles ;

|| : ?usage  ( flag -- )
     IF ." usage: cc file.c" cr
     rdrop THEN ;

|| : .errors-occurred  ." error(s) occured" ;

~ : cc  ( -- )
     clearstack
     \prof profiler-start
     \time reset-50ms-timer read-50ms-timer
     init
     bl word   dup c@ 0= ?usage
     dup exe-name strcpy
         source-name strcpy
     exe-name count 2-
     dup exe-name c!  + @
    [ ascii . ascii c 256 * + ] literal
     -  ?usage
     scratch-outs
     cr cr ." compiling" cr
     compile-source  cr
     any-errors? @
        IF .errors-occurred cr
        close-files scratch-all exit
        THEN
     \prof profiler-timestamp
     ." linking" cr
     link-all  cr
     scratch-tmps
     any-errors? @
        IF .errors-occurred
        ELSE ." done" THEN cr
     \time read-50ms-timer - ms. cr
     \prof profiler-end
     ;
