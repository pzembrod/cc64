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

Source: ```src/runtime/ctype-petscii.a``` (acme 6502 assembly)  
Tests: ```tests/lib/ctype/*-test.c```

## ```stdio.h```

Since cc64 has no typedef or struct, file handles (short ```fh```)
are int values, namely the CBM logical file number.

No default file handles stdin, stdout or stderr are defined.

```int fopen(char* filename, char* mode);```

The ```mode``` parameter does not take the standard values
like "r", "w", "a", "r+", "rb", "wb+", "w+x" etc.
Instead, it is intended for CBM-typical filename suffixes
used with OPEN like ",s,r", ",p,w" or ",s,a". In fact, filename
and mode are simply concatenated before passing them to OPEN.

As a consequence, the calls ```fopen("myfile", ",s,r")```,
```fopen("myfile,s", ",r")```, ```fopen("myfile,s,r", "")```,
```fopen("myfile,s,r", NULL)``` and even ```fopen("myfile,s,r")```
are all equivalent.

The returned file handle, in case of success, is a CBM logical file
number, in the range from 7 to 14 (inclusive). In case of failure,
0 is returned, matching the standard.

```int fclose(int fh);```

follows the standard, except for the type of ```fh```.

```int fgetc(int fh);```

follows the standard, except for the type of ```fh```.

```int fputc(int c, int fh);```

follows the standard, except for the type of ```fh```.

```char* fgets(char* str, int count, int fh);```

follows the standard, except for the type of ```fh```.

```char* fputs(char* str, int fh);```

follows the standard, except for the type of ```fh```.

```int putchar(int c);```

Since there is no stdout, ```putchar(c)``` writes character c
to the current output channel, by default the screen.
Return value follows the standard.

```int puts(char* str);```

Since there is no stdout, ```puts(str)``` writes string str
to the current output channel, by default the screen.
Return value follows the standard.

```int remove(char* filename);```

follows standard, with the caveat that only direct problems with
the serial bus are detected and signaled via a non-zero return
value. A zero return value doesn't make a statement about the
success of the actual file remove operation.

Source: ```src/runtime/fileio.a``` (acme 6502 assembly)  
Tests: ```tests/lib/stdio/*-test.c```

```int printf(char* fmtstr, ...);```

```int fprintf(int fh, char* fmtstr, ...);```

```int sprintf(char* buffer, char* fmtstr, ...);```

Only the format specifiers %%, %c, %s, %d, %u, %x and %X are
supported. Field width specifiers like %5d and %05d are supported
for %d, %u, %x and %X, but not for %c and %s. No further format
modifiers are supported.

Return value follows the standard.

Source: ```src/runtime/printf.a``` (acme 6502 assembly)  
Tests: ```tests/lib/printf/*-test.c```

## stdlib.h

```int abs(int j);```

follows standard.

```int atoi(char *s);```

follows standard.

Source: ```src/lib/stdlib/*.c```  
Tests: ```tests/lib/stdlib/*-test.c```

```int rand();```

```int srand(int seed);```

follows standard.

Source: ```src/runtime/rand.a``` (acme 6502 assembly)  
Tests: ```tests/lib/stdlib/rand-test.c```

## string.h

```char *memchr(char *s, int c, int n);```

follows standard.

```int memcmp(char *s1, char *s2, int n);```

follows standard.

```char *memcpy(char *s1, char *s2, int n);```

follows standard.

```char memmove(char *s1, char *s2, int n);```

follows standard.

```char *memset(char* s, int c, int n);```

follows standard.

Source: ```src/lib/string/*.c```  
Tests: ```tests/lib/strmem/*-test.c```

```char *strcat(char *s1, char *s2);```

follows standard.

```char *strchr(char *s, int c);```

follows standard.

```int strcmp(char *s1, char *s2);```

follows standard.

```char *strcpy(char *s1, char *s2);```

follows standard.

```int strcspn(char *s1, char *s2);```

follows standard.

```int strlen(char *s);```

follows standard.

```char *strncat(char *s1, char *s2, int n);```

follows standard.

```int strncmp(char *s1, char *s2, int n);```

follows standard.

```char *strncpy(char *s1, char *s2, int n);```

follows standard.

```char *strpbrk(char *s1, char *s2);```

follows standard.

```char *strrchr(char *s, int c);```

follows standard.

```int strspn(char *s1, char *s2);```

follows standard.

```char *strstr(char *s1, char *s2);```

follows standard.

Source: ```src/lib/string/*.c```  
Tests: ```tests/lib/string/*-test.c```
