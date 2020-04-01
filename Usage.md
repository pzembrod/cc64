# Usage

As said, cc64 and peddi are written in FORTH. After starting them
You'll get an OK prompt, and HELP will list You the availible commands.
Some commands require numeric parameters; those must be entered _before_
the command. We're FORTH, so we're RPN (reversed polish notation). The
commands are:

```
help      -- list all commands
cc file.c -- compile file.c
ed file   -- edit file (only available in the combined compiler+editor binary)
cat file  -- type the contents of file on the screen
dos       -- read and print the floppy's error channel
dos xxx   -- send the command xxx to the floppy
dir       -- list the directory
mem       -- show the compiler's memory setup
xxx set-himem -- set the limit of the compiler's memory to xxx. Don't
          change this to a value greater than $cbd0 if You want to use
          c-charset. xxx may be a decimal number or a hex number,
          preceeded by a $
xxx set-heap -- sets the heap to xxx links. For each function in a C
          program that is used before it is defined (a prototype must
          exist before the first call) one link is needed.
xxx set-hash -- sets the hash table size for global symbols. Needs at
          least one element per global symbol in a C program. Should
          be sized a bit generous otherwise hashing will be inefficient.
xxx set-symtab -- sets the symbol table size (used both for local and
          global symbols). Must be increased if You run into a Symbol
          table overflow error.
xxx set-code -- sets the size of the code buffer. The code for any C
          function being compiled must fit into this buffer. Otherwise
          You get a function too long error. Then increase the code
          buffer size or split the long function up in two or more.
The size of the static buffer is determined by the remaining memory.
This size is not critical. It should be positive, though. :)
xxx yyy set-stacks -- sets the size of data and return stack and
          resets the system. The stacks'size determine the maximum
          depth of arithmetic expressions and the maximum number of
          nested compound statements the compiler can handle. Stack
          overflows are checked; I hope those checks are reliable.
          If the compiler should behave strangely on a complicated
          (i.e. deeply nested) expression RELOAD IT FROM DISK and set
          the stack sizes to higher values.
saveall name -- saves the complete compiler together with its actual
          memory settings.
bye       -- leave to basic
```

Peddi - how to use
------------------
Peddi is a small full screen, scrolling PETSCII editor. No limit in line
length (exept memory). Memory overflow is signalled by a double flash
of the screen border.
You call peddi with
 `ed filename`
The peddi key bindings:
cursor keys - as usual
return - split line
shift-return - goto begin of next line
del - del left of cursor or join lines
inst - insert a blank line
home - redraw screen
clr - kill line
F1 - 20 lines up
F7 - 20 lines down
ctrl-a - begin of line
ctrl-e - end of line
ctrl-d - del under cursor
ctrl-@ - del to cursor
ctrl-^ - del from cursor
ctrl-p - clear line
ctrl-w - save text
ctrl-x - exit and save text
ctrl-c - quit without saving

