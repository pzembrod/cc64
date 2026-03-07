
\ hold current here on the stack, allocate 2k
\ on the tmpheap (6502asm takes 1809 bytes) and
\ set here to that allocated space.
here   $800 tmp-hallot dp !

cr .( tmpheap transient assembler start ) here u.

  include 6502asm.fth

cr .( tmpheap transient assembler end ) here u.

\ restore the remembered here. 6502asm now lives
\ completely on the tmpheap.
dp !
