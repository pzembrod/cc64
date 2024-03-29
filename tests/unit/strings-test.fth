
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen strings-test.log

\needs \prof  ' \ alias \prof immediate

  ' noop   alias ~
  ' noop  alias ~on
  ' noop  alias ~off

  include notmpheap.fth
  \ $1000 mk-tmp-heap

  : dos  ( -- )
   bl word count ?dup
      IF 8 15 busout bustype
      busoff cr ELSE drop THEN
   8 15 busin
   BEGIN bus@ con! i/o-status? UNTIL
   busoff ;


  decimal
  include util-words.fth
  include tester.fth
  decimal
  include trns6502asm.fth
  include tracer.fth
  include strings.fth
  clear
  include strtab.fth
  cr

  T{ $100 alpha? -> 0 }T
  T{ 0 alpha? -> 0 }T
  T{ ascii a alpha? -> -1 }T
  T{ ascii z alpha? -> -1 }T
  T{ ascii A alpha? -> -1 }T
  T{ ascii Z alpha? -> -1 }T
  T{ ascii a 1- alpha? -> 0 }T
  T{ ascii z 1+ alpha? -> 0 }T
  T{ ascii A 1- alpha? -> 0 }T
  T{ ascii Z 1+ alpha? -> 0 }T

  T{ $100 num? -> 0 }T
  T{ 0 num? -> 0 }T
  T{ ascii 0 num? -> -1 }T
  T{ ascii 9 num? -> -1 }T
  T{ ascii 0 1- num? -> 0 }T
  T{ ascii 9 1+ num? -> 0 }T

  T{ $100 alphanum? -> 0 }T
  T{ 0 alphanum? -> 0 }T
  T{ ascii a alphanum? -> -1 }T
  T{ ascii z alphanum? -> -1 }T
  T{ ascii A alphanum? -> -1 }T
  T{ ascii Z alphanum? -> -1 }T
  T{ ascii a 1- alphanum? -> 0 }T
  T{ ascii z 1+ alphanum? -> 0 }T
  T{ ascii A 1- alphanum? -> 0 }T
  T{ ascii Z 1+ alphanum? -> 0 }T
  T{ ascii 0 alphanum? -> -1 }T
  T{ ascii 9 alphanum? -> -1 }T
  T{ ascii 0 1- alphanum? -> 0 }T
  T{ ascii 9 1+ alphanum? -> 0 }T


18 string-tab keywords

~ x <do>       x" do"
~ x <if>       x" if"
~ x <for>      x" for"
~ x <int>      x" int"
~ x <auto>     x" auto"
~ x <case>     x" case"
~ x <char>     x" char"
~ x <else>     x" else"
~ x <goto>     x" goto"
~ x <break>    x" break"
~ x <while>    x" while"
~ x <extern>   x" extern"
~ x <return>   x" return"
~ x <static>   x" static"
~ x <switch>   x" switch"
~ x <default>  x" default"
~ x <cont>     x" continue"
~ x <register> x" register"

end-tab

  T{ keywords <do> string[] -> keywords 2+ }T
  .( string[<do>]) cr
  keywords <do> string[] >string count type cr

keywords 2 8 length-index keywords-index
  <do> idx,
  <for> idx,
  <auto> idx,
  <break> idx,
  <extern> idx,
  <default> idx,
  <cont> idx,
end-index

create "goto" ," goto"
create "next" ," next"
create "long" ," somethingverylong"
  hex
  \ debug find-via-index
  T{ "long" keywords-index find-via-index -> false }T
  T{ "next" keywords-index find-via-index -> false }T
  T{ "goto" keywords-index find-via-index -> <goto> true }T

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
