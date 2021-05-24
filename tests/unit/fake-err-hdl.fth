
\ fake errorhandler

variable any-error-count
variable any-fatal-count

create errormessage-count errormessage @ cells allot

: init-error  any-error-count off
              any-fatal-count off
              errormessage-count errormessage @ cells erase ;
  init: init-error

doer printcontext

: error ( errnum -- )
    *compiler* min
    errormessage-count over cells + 1 swap +!
    errormessage swap string[]
    >string count type cr
    printcontext
    1 any-error-count +! ;

: ?error ( flag errnum -- )
    swap IF error ELSE drop THEN ;


: fatal ( errnum -- )
    error  1 any-fatal-count +!
    true abort" fatal error" ;

: ?fatal ( flag errnum -- )
    swap IF fatal ELSE drop THEN ;

: expect-error ( errnum -- )
    dup *compiler* u> abort" expecting illegal error message"
    errormessage-count swap cells + -1 swap +!
    -1 any-error-count +! ;

: check-error-messages ( -- )
    errormessage @ 0 DO errormessage-count I cells + @
    ?dup IF 1 #ERRORS +!  cr ." FAIL: "
      0< IF ." missing expected" ELSE ." unexpected" THEN
      ."  error message: " errormessage I string[] >string count type
    THEN LOOP
    any-error-count @ ?dup
      IF cr ." FAIL: " . ." unexpected error(s)" THEN
    any-fatal-count @ ?dup
      IF cr ." FAIL: " . ." unexpected fatal(s)" THEN ;
