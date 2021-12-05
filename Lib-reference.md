# LibC Reference

cc64's libc is based on [PDCLib](https://pdclib.rootdirectory.de/),
but offers only the following subset of functions,
with in some cases slightly modified behaviour.
Left out were functions that didn't seem feasible
or didn't make sense given the limitations of the compiler
and the platform.

## ```ctype.h```

follows mostly the PETSCII character table.

```int isdigit(int c);```

follows standard.

```int isalnum(int c);```

```int isalpha(int c);```

recognize 0x41-0x5a (a-z), 0x61-0x7a (A-Z), 0xc1-0xda (A-Z)
and 0x5f (underscore, borrowed from ASCII) as alpha characters.

```int islower(int c);```

recognizes 0x41-0x5a as lowercase characters.

```int isupper(int c);```

recognizes both 0x61-0x7a and 0xc1-0xda
as uppercase characters.

```int tolower(int c);```

converts 0x61-0x7a and 0xc1-0xda to 0x41-0x5a.

```int toupper(int c);```

converts 0x41-0x5a to 0xc1-0xda.

```int isspace(int c);```

is slightly inconsistent with PETSCII as it recognizes
ASCII space and HT to CR (0x09 to 0x0d) as whitespace.

Source: src/runtime/ctype-petscii.a (acme 6502 assembly)  
Tests: tests/lib/ctype/*-test.c

## ```stdio.h```

Since cc64 has no typedef or strucht, file handles (short ```fh```)
are just int values, namely the CBM logical file number.

```int fopen(char* filename, char* mode);```

```int fclose(int fh);```

```int fgetc(int fh);```

```int fputc(int c, int fh);```

```char* fgets(char* str, int count, int fh);```

```char* fputs(char* str, int fh);```

```int putchar(int c);```

```int puts(char* str);```

Source: src/runtime/fileio.a (acme 6502 assembly)  
Tests: tests/lib/stdio/*-test.c

```int printf(char* fmtstr, ...);```

```int fprintf(int fh, char* fmtstr, ...);```

```int sprintf(char* buffer, char* fmtstr, ...);```

Source: src/runtime/printf.a (acme 6502 assembly)  
Tests: tests/lib/printf/*-test.c
