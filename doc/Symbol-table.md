# Symbol Table

## Overview

The symboltable.fth module providess the local and the global symbol table
for the C compiler, and because of the hack how preprocessor macros are
limited to and implemented as global constants, also for the preprocessor.

The basic interface words are

* `findlocal ( name -- spfa/0 )`
* `putlocal ( name -- spfa )`
* `findglobal ( name -- spfa/0 )`
* `putglobal ( name -- spfa )`

for finding and putting a symbol in the local and global symbol table.
Each takes a name (counted string) as a parameter and returns a
`symbol payload field address (spfa)` from which to get or into which to
store the symbol's data such as type and value, or 0 in case the find*
words haven't found a symbol.

Additionally there are two words

* `nestlocal ( -- )`
* `unnestlocal ( -- )`

which open
and close scopes of the local symbol table, essentially the `{` ... `}` blocks
in the C program, in which the programmer can redefine local variable names
without causing a double defined symbol error.

## Memory

To store symbol names and payload, both symbol tables make shared use of a
memory buffer `symtab[` to `]symtab`, sometimes in shorthand referenced as
`symtab[]`. The global symbol table additionally uses the buffer `hash[` to
`]hash` for its hash table. Both buffers are provided by memman.

* The local
symbol table lives at the upper end of `symtab[]`, growing downwards.
Its lower end is held in the pointer `locals>`.
* The global symbol table lives at the lower end, growing upwards.
Its upper end is held in the pointer `globals>`.  
* `locals> @ globals> @ -` yields the remaining free space in the combined
symbol table. See also `check-space`.

The local symbol table grows and shrinks through the compile of each
C function, as local `{` ... `}` scopes are opened and closed, and gets
emptied each time a function is completely compiled.
The global symbol table, in comparison, only grows throughout the compile run
of a program, reaching its maximum size when the compilation is finished.

A corrolary of this is that, for a given size of `symtab[]`, cc64 may
be able to compile functions with more local symbols early in the compile run
when still few global symbols are defined, than later when the global
symbol table has filled somewhat.

`.symtab-status ( -- )` gets called after a compile run and prints some
statistics about symbol table use in this run:

* global symtab size in bytes at the end of the run
* maximum local symtab size during the run
* minimal free symtab space during the run
* number of hash collisions in the global symtab

Note that the first 3 values don't add up to the overall size of `symtab[]`
because the values are taken at different times.

## Local Symbol Table

An entry in the local symbol table has the following format in memory:

* **name**: counted string, limited to `/id` length, currently 31.
* **symbol payload field**: 2 cells, `/sym-payload` bytes

As mentioned above, the address of the symbol payload field of a symbol
is referenced in stack comments as `spfa` (symbol payload field address).
The address of the name is at the same time the address of the entire symbol
in the symbol table.

Two single-byte pseudo entries in the symbol table are used as search end
markers; their values need to be larger than `/id` to distinguish them from
count bytes of names:

* `)local` = 255 marks the upper end of the local table; during
  initialization it is placed at `]symtab - 1`.
* `)block` = 254 marks the upper end of the symbols of the current `{}` block.
  It is added to the bottom of the local symbols by `nestlocal` and removed
  again by `unnestlocal`.

The actual search through the local symbol table is implemented in

* `(findloc)  ( name end-marker -- spfa/0 )`

and it is a simple linear search,
starting at the lower end `locals> @` and ending when either `name` is found
or when at least the specified end marker is reached. "At least" implies a
hierarchy, meaning that `)local` implies `)block`. This saves the need to
initialize the table with a `)block` in addition to the  `)local` marker.
The "at least" is implemented simply with a `>=` condition to end the
search loop and through the fact that `)local > )block`.  
`(findloc)` returns the `spfa` if a symbol is found, and 0 if it isn't found.

* `findlocal ( name -- spfa/0 )`

trims `name` to max `/id` length and calls `(findloc)` with end marker
`)local`, so the whole local symbol table is searched.

* `putlocal ( name -- spfa )`

trims `name` to max `/id` length and calls `(findloc)` with end marker
`)block`, because a double-defined-symbol error is only issued if `name`
is found in the symbol table section of the current `{}` block. After thus
making sure `name` doesn't exist yet, and after ensuring enough remaining
space, `putlocal` adds a new entry for `name` to the lower end of the
local symbol table and returns its `spfa` so parser or codegen can populate
the symbol's payload.

* `nestlocal ( -- )`

opens a new local `{}` block scope by adding a new `)block` mark to the
lower end of the local symbol table.

* `unnestlocal ( -- )`

closes and removes a local `{}` block scope by finding the first
`)block` mark starting at the bottom of the local symbol table
i.e. from `locals> @`. It then discards the block scope by pointing
`locals>` at the address above the found `)block` mark.

Both `(findloc)` and `unnestlocal` limit their search to `]symtab`.
In both cases it's an error condition (i.e. something's wrong with cc64)
if the search actually reaches `]symtab`: `(findloc)`'s search should
latest end at the `)local` mark at `]symtab - 1`. And if `unnestlocal`
reaches `]symtab` without finding a `)block` mark, then `unnestlocal` was
called without a matching prior `nestlocal` call.

I went with simple linear search for the local symbol table because it made
it easy to implements the nexted block scopes, and because I figured that
C functions typically don't have very many local variables anyway, so the
list to search through will mostly be short. So far profiling showed
the symbol table to be no particular hotspot. And as two data points:
when compiling the libc and the e2e test suite that come with cc64,
for each of them the local symbol table takes a max size of 40 bytes, vs.
~720 bytes for the global symbol table.

## Global Symbol Table

The global symbol table must meet slightly different requirements than the
local symbol table. It has no need for nest/unnest kind of scopes, it will
simply continue to grow until the end of the compile run, and it will
therefore need to hold many more symbols, and a simple linear search would
thus be more costly. I used this as an excuse and opportunity to try my
hand at implementing a hash table, a concept I had only recently read about
when in 1990 I wrote the first version of what would become `symboltable.fth`.

The basic approach was and is to store the symbols with their variable length
names and their payload in the `symtab[]` buffer shared with the local
symbol table, as described above in the [Memory](#memory) section, and to
maintain a separate buffer `hash[` to `]hash`, shorthand `hash[]`, as the
actual hash table, indexed by names' hash values, and each cell containing
a pointer into the global part of `symtab[]`.

The choice of a hash collision resolution algorithm may be worth mentioning.
My initial code used
[open addressing](https://en.wikipedia.org/wiki/Hash_table#Open_addressing).
I learned about this name and about the fact that there are alternatives
while revisiting my code in prepartation of this documentation. I then
decided to change to
[separate chaining](https://en.wikipedia.org/wiki/Hash_table#Separate_chaining)
for collision resolution, because it a) doesn't hard-limit the global symbol
table capacity to the hash table size, and b) its performance degrades less
when the hash table fills. For cc64's memory-constrained environment this
seems to be the right trade-off; I didn't measure, though. Also, separate
chaining was easy to implement because `hash[]` contained pointers, not values.

A global symbol table entry in `symtab[]` has the following format in memory:

* **name**: counted string, limited to `/id` length, currently 31.
* **symbol payload field**: 2 cells, `/sym-payload` bytes
* **global link field**: 1 cell, link to the next global symbol table entry
  in the same hash bucket, or 0 if it's the last in the list.

Similar to `(findloc)` for the local symbol table, the  actual search
through the global symbol table is implemented in

* `(findglb) ( name -- spfa  true / hash[]-or-glf-adr false )`

The true/false flag indicates whether `name` was found as a global symbol.
If `true`, then `spfa` is the address of the symbol's payload field.
If `false`, then `hash[]-or-glf-adr` is the address where the pointer to a new
symbol could be stored if `(findglb)` had been called by `putglobal`.
`hash[]-or-glf-adr` will be either the address of `name`'s bucket within
`hash[]` directly, or the address of global link field of the last symbol in
the linked list attached to `name`'s bucket in `hash[]`.

* `findglobal ( name -- spfa/0 )`

trims `name` to max `/id` length and calls `(findglb)`.

* `putglobal ( name -- spfa )`

trims `name` to max `/id` length and calls `(findglb)`. After thus
making sure `name` doesn't exist yet, and after ensuring enough remaining
space, `putglobal` adds a new entry for `name` to the end of the global
symbol table, starting at `globals> @`, stores its address to the
`hash[]-or-glf-adr` that `(findglb)` returned, thereby establishing or
extending the link chain of `name`'s bucket in `hash[]`, and returns
the new symbol's `spfa` so parser or codegen can populate the symbol's payload.

## Symbol payload field usage by codegen

Access to and layout of the symbol payload field `spf` is owned by codegen.
A symbol's value and type are stored to a `spf` using `sym!` and fetched
from a `spf` using `sym@`. `sym.type!` and `sym.type@` do the same with
just a symbol's type. Incidentally, `( val type )` is usually shortened
to `( obj )` in stack comments in codegen and parser.

## Bank Switching Considerations

The interface between symbol table and codegen/parser matters for the planned
future use of X16's banked RAM. Parser and codegen and possibly v-assembler
are slated to be moved into one of X16's RAM banks. Another attractive use
of a RAM bank would be for the symbol table. With the current interface this
would require two bank switches for each symbol table access by parser or
codegen: one for finding or creating a symbol, and one for fetching or storing
the payload. It would of course be attractive to bundle the two operations
so only one bank switch would be needed. It is however so that parser and
codegen don't call find/putlocal/global and sym@/! in repeated similar
patterns that could be extracted into words which could encapsule the single
bank switch. Rather it is so that find/putlocal/global are embedded
into more complex logic both in parser and in codegen, and what happens
before the sym@/! call depends on where in the parsing flow the call was
made, and often whether or not a local or global symbol was found or not.

So the current design with 2 clear places wher switches from parser bank
to symbol table bank and back could be placed is probably the best tradeoff
between performace and code clarity.
