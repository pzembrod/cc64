\ *** Block No. 24, Hexblock 18

\ errormessages              20sep94pz

\prof profiler-bucket [memman-errmsg]

\ *** Block No. 25, Hexblock 19

\ errormessages                11sep94pz

~ 42 string-tab errormessage

~ x *syntax*      x" syntax error"
~ x *eof*         x" end of file"
~ x *symovfl*     x" symtab full"
~ x *doubledef*   x" double defined symbol"
~ x *glbovfl*     x" hash table full"
~ x *functoolong* x" function too long"
~ x *undef*       x" undefined symbol"
~ x *nofunc*      x" bad function call"
~ x *inc-nest*    x" include nests too deep"
~ x *nolval*      x" l-value needed"
~ x *nofctnptr*   x" function ptr needed"
~ x *noptr*       x" pointer needed"
~ x *noconst*     x" const expression needed"


\ *** Block No. 26, Hexblock 1a

\   errormessages              11sep94pz

~ x *noswitch*    x" no active switch"
~ x *ill-brk*     x" nothing to break/continue"
~ x *ill-default* x" illegal default"
~ x *heapovfl*    x" heap overflow"
~ x *!=type*      x" incompatible type"
~ x *lex*         x" lexical error"
~ x *eol*         x" eol in str/chr lit"
~ x *comment*     x" comment unclosed from line "
~ x *ignored*     x" word ignored: "
~ x *expected*    x"  expected"
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
     x" preprocessor in string"
~ x *memsetup*  x" low mem for statics"
~ x *nolayout*  x" no #pragma cc64"
~ x *bad-main*  x" main is no function"
~ x *link*      x" linker file error"
~ x *obj-long*  x" obj file too long"
~ x *obj-short* x" obj file too short"
~ x *stack*     x" stack overflow"
~ x *rstack*    x" return stack overflow"
~ x *compiler*   x" compiler error"
~ x *codetoolong*  x" code too long"
~ x *fastcall*  x" fastcall error"

end-tab

\ see issue 11. this here was broken.
\ ~ create err-blk  0 ,

\ | : *compiler* ( -- )
\      blk @  err-blk @ +  >in @ 41 /
\      1024 * + [compile] literal
\      compile err-blk  compile !
\      compile (*compiler* ; immediate

\prof [memman-errmsg] end-bucket
