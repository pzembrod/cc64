
\ This is a hack for compiling the parser/codegen/v-asm
\ group of sources. Together their headers use almost 6k
\ on the tmpheap. With 1809 bytes for 6502asm this almost
\ fills the fixed 8k tmpheap on the X16 and requires 8k tmpheap
\ on the C64.

\ The hack exploits the facts that only v-assembler.fth needs
\ 6502asm, while codegen.fth and parser.fth don't, and that
\ the tmpheap grows from to to bottom in its available memory.

\ 6502asm (1809 bytes) is put at the bottom of tmpheap's memory.
\ Then while v-assembler is loaded, its headers in tmpheap
\ will grow only about ~2k from the top. After v-assembler is
\ loaded, a custom word clears out 6502asm again, so its memory
\ can be reused for headers.


\ Hold current here on the stack, then set here
\ to the start of the tmpheap's available space.
here   tmpheap[ @ dp !

cr .( special tmpheap transient assembler start ) here u.

  include 6502asm.fth

cr .( special tmpheap transient assembler end ) here u.

  : clear-tmpx6502asm  ( -- )
    push ]tmpheap
    tmpheap[ @ $0800 + ]tmpheap !
    remove-tmp-words ;
cr
.( clear-tmpx6502asm end ) here u.

\ restore the remembered here. 6502asm now lives
\ completely on the heap.
dp !
