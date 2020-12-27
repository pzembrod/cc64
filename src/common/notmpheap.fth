
\ When no tmpheap mechanism is needed, i.e. all temporary names
\ of a project fit onto the regular heap at once, then this zero-cost
\ implementation can be used which directs all tmpheap definitions
\ to the regular heap.

~ ' |    alias ||
~ ' |on  alias ||on
~ ' |off alias ||off

~ ' noop alias tmpclear
