
\ hold current here on the stack, allocate 2k
\ on the heap (6502asm takes 1809 bytes) and
\ set here to that allocated space.
here   $800 hallot  heap dp !

cr .( heap transient assembler start ) here u.

  include 6502asm.fth

cr .( heap transient assembler end ) here u.

\ restore the remembered here. 6502asm now lives
\ completely on the heap.
dp !
