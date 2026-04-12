\ error messages

\prof profiler-bucket [memman-errmsg]

~ 42 string-tab errormessage

~ x *syntax*      x" syntax error"
~ x *eof*         x" end of file"
~ x *fileio*      x" file i/o"
~ x *symovfl*     x" symtab full"
~ x *doubledef*   x" double defined symbol"
~ x *functoolong* x" function too long"
~ x *undef*       x" undefined symbol"
~ x *nofunc*      x" bad function call"
~ x *inc-nest*    x" include nests too deep"
~ x *nolval*      x" l-value needed"
~ x *nofctnptr*   x" function ptr needed"
~ x *noptr*       x" pointer needed"
~ x *noconst*     x" const expression needed"

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

\ ~ x *preprocess-in-string*
\      x" preprocessor in string"
~ x *memsetup*  x" bad mem setup"
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
~ x *unbalanced* x" unbalanced stack"

end-tab

\ see issue 11. this here was broken.
\ ~ create err-blk  0 ,

\ | : *compiler* ( -- )
\      blk @  err-blk @ +  >in @ 41 /
\      1024 * + [compile] literal
\      compile err-blk  compile !
\      compile (*compiler* ; immediate

\prof [memman-errmsg] end-bucket
