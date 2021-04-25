\ *** Block No. 24, Hexblock 18

\ errormessages              20sep94pz

\ *** Block No. 25, Hexblock 19

\ errormessages                11sep94pz

~ 40 string-tab errormessage

~ x *syntax*      x" syntax error"
\ x *in-file*     x" source file error"
~ x *eof*         x" end of file"
~ x *symovfl*
     x" symbol table overflow"
~ x *doubledef*
     x" double defined symbol"
~ x *glbovfl*
     x" hash table overflow"
~ x *functolong*  x" function too long"
\ x *out-file*    x" output file error"
~ x *undef*       x" undefined symbol"
~ x *nofunc*      x" bad function call"
~ x *inc-nest*
     x" include nesting too deep"
~ x *noref*       x" reference needed"
~ x *novector*    x" vector needed"
~ x *noptr*       x" pointer needed"
~ x *noconst*
     x" constant expression needed"


\ *** Block No. 26, Hexblock 1a

\   errormessages              11sep94pz

~ x *noswitch*    x" no active switch"
~ x *ill-brk*
     x" nothing to break or continue"
~ x *ill-default* x" illegal default"
~ x *heapovfl*    x" heap overflow"
~ x *!=type*      x" incompatible type"
~ x *lex*         x" lexical error"
~ x *eol*
     x" unexpected end of line"
~ x *comment*
     x" unclosed comment from line "
~ x *ignored*     x" word ignored: "
\ x *file*        x" file error"
\ x *stackovfl*   x" stack overflow"
~ x *expected*    x" expected: "
~ x *initer*      x" bad initializer"
~ x *???*         x" makes no sense"
~ x *double-func* x" double function"
~ x *double-ptr*  x" double pointer"
~ x *param*       x" bad parameter"
~ x *longline*    x" overlong line"
~ x *preprocessor* x" preprocessor"


\ *** Block No. 27, Hexblock 1b

\   errormessages              10may20pz

~ x *preprocess-in-string*
     x" preprocessor call in string"
~ x *memsetup*
  x" bad memory setup: no static space"
~ x *nolayout*  x" no '#pragma cc64'"
~ x *bad-main*  x" main's no function"
~ x *link*      x" linker file error"
~ x *obj-long* x" object file too long"
~ x *obj-short*
    x" object file too short"
~ x *stack*     x" stack overflow"
~ x *rstack*  x" return stack overflow"
~ x *compiler*   x" compiler error"

end-tab

\ see issue 11. this here was broken.
\ ~ create err-blk  0 ,

\ | : *compiler* ( -- )
\      blk @  err-blk @ +  >in @ 41 /
\      1024 * + [compile] literal
\      compile err-blk  compile !
\      compile (*compiler* ; immediate
