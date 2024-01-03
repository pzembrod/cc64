\ *** Block No. 54, Hexblock 36

\ errorhandler : loadscreen    20sep94pz

\prof profiler-bucket [memman-errhdlr]

\ *** Block No. 55, Hexblock 37

\   errorhandler               11sep94pz

~ variable any-errors?
~ variable context?
~ doer printcontext

~ : init-error  any-errors? off
                context? off ;
    init: init-error

~ doer close-files  ( -- )
~ doer scratch-all  ( -- )


\ *** Block No. 56, Hexblock 38

\   errorhandler               10may20pz

~ : error ( errnum -- )
     errormessage swap string[]
     cr >string count type  cr
     printcontext  any-errors? on ;

~ : ?error ( flag errnum -- )
    swap IF error ELSE drop THEN ;


~ : fatal ( errnum -- )
     error
     \ *compiler* error handling was
     \ broken. See issue 11.
     \ dup error  (*compiler* =
     \   IF err-blk @ dup 1024 /
     \  swap 1023 and ." location: blk "
     \   . ."  line " . cr THEN
     close-files scratch-all
     true abort" fatal error" ;

~ : ?fatal ( flag errnum -- )
     swap IF fatal ELSE drop THEN ;

\prof [memman-errhdlr] end-bucket
