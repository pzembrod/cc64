# Why Forth?

The reason for writing cc64 in Forth were the compact code that Forth
generates, and the fact that ultraFORTH was by far the most powerful
development environment on the C64 that I could get hold of back in 1989.

My first stab at writing an actual C compiler used Dirk Zabel's macro
assembler ASSI/M. As far as I was aware, it was the flagship of C64 assemblers,
at least in Germany. It featured string processing of macro parameters,
and it came with two nice macro libraries for structured
programming and 16-bit operations. I went a bit crazy extending those and ended
up with something semantically if not syntactically close to Small C (it had
functions, local variables, pointers, arrays). I called it S65+ and wrote the
first version of a C scanner and a symbol table using that. I did notice two
limitations, however. Assembling was terribly slow; I found out that each
source line macro-expanded on average into ~100 lines.
And the produced code was lengthy;
I saw a risk that I would run out of C64 memory ere the compiler was ready.
So I looked for alternatives.

I probably ran across
[ultraFORTH aka volksFORTH](https://forth-ev.de/wiki/projects:volksforth)
in one of the two computer magazines I read then (64'er and c't), and decided
to try it out. And after struggling for a while with wrapping my mind around the
concepts of Forth, esp. the part where you need to be aware which code runs at
compile time and which at run time, I grew to like the language, and became
positively enthusiastic about it. I learned to make use of defining words -
in another language you would call them language or compiler enhancements - in
quite a few parts of cc64. It didn't hurt, either, that ultraFORTH came with
an assembler that I could use and integrate. And the code compactness did
pay off: Two 170k disks worth of source (though not 100% full) condense
down to just over 18k of compiled code, on top of the ~15-16k Forth core on top
of which it is compiled. The subsequent wish for a smaller Forth core is
obvious, I guess, but that's another story.

Coming back to my code ~30 years later, and diving back into Forth (having
used C, Object Pascal, Perl, C++, Python and Java as my main workhorse
languages since then, in roughly that order), I still feel the fascination
and enjoy the simplicity and power of Forth. I'm not sure I would use or
recommend it for the kind of large team-sized efforts of my current day job.
I imagine the semantic awareness for e.g. Java that I enjoy from today's IDEs
and static analysis tools would be very difficult to achive given the
flexibility of Forth. But I'm definitely having fun again with Forth on a hobby
basis, just as I was having way back.
