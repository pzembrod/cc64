
/* ufscr2file.c, (c) Philip Zembrod, 1995, 2007, 2019, 2020 */

/* Converts a D64 disk image of a C64 ultraFORTH src screen disk
 * to an ASCII-File, in the first place for viewing, later perhaps also
 * to use as Forth src file. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "openfiles.h"
#include "petscii.h"

int nextchar(FILE *in) {
  /* Note: The track & sector count is a hack; it is only correct up to
   * track 18 after which tracks have less than 21 sectors. The only
   * purpose of the track/sector count is to skip sectors 0-2 of track
   * 18, i.e. BAM, directory and one more sector unused by Forth blocks.
   */
  static int track = 1, sector = 0, byte = 0;
  int c, skip;

  do {
    c = fgetc(in);
      if(c == EOF) break;
      skip = (track == 18) && (sector < 3);
      byte++;
      if ((byte & 255) == 0) {
        sector++;
        if (sector > 20) {
          sector = 0; 
          track++;
        }
      }
    } while (skip);
  return c;
}

void buffered_putchar(FILE *out, char c) {
  static char line[100], *p=line;
  if (p - line > 95) {
    fprintf(stderr, "!!! overlong line !!!\n");
    exit(1);
  }
  if (c == '\n') {
    while (p > line && *(p - 1) == ' ') p--;
    *p-- = '\0';
    if (p > line + 40 && *p == '\\' && *(p-1) == ' ') {
      p -= 2;
      while (p > line && *(p - 1) == ' ') p--;
      *p-- = '\0';
    }
    fprintf(out, "%s\n", line);
    p=line;
    return;
  }
  *p++ = c;
}

int readwriteblock(FILE *in, FILE *out, int n) {
  int line, col, c;
  fprintf(out, "\n\\ *** Block No. %d, Hexblock %x\n\n", n, n);
  for (line = 0; line < 25; line++) {
    for (col = 0; col < (line == 24 ? 40 : 41); col++) {
      c = nextchar(in);
      if (c == EOF) {
        fprintf(out, "\n### premature end of input file ###\n");
        return 1;
      }
      buffered_putchar(out, (char) petscii2ascii(c));
    }
    buffered_putchar(out, '\n');
  }
  return 0;
}

#define BLOCKSIZE 1024

int readblock(FILE *in, short buf[], int n) {
  int i, c;
  for (i = 0; i < BLOCKSIZE; ++i) {
    c = nextchar(in);
    if (c == EOF) {
      fprintf(stderr, "\n### premature end of input file ###\n");
      return 1;
    }
    buf[n * BLOCKSIZE + i] = c;
  }
  return 0;
}

int writeblock(FILE *out, short buf[], int n) {
  int line, col, i;
  fprintf(out, "\n\\ *** Block No. %d, Hexblock %x\n\n", n, n);
  for (line = 0, i = 0; line < 25; ++line) {
    for (col = 0; col < (line == 24 ? 40 : 41); col++, ++i) {
      buffered_putchar(out, (char) petscii2ascii(buf[n * BLOCKSIZE + i]));
    }
    buffered_putchar(out, '\n');
  }
  return 0;
}

int writeshadowedblock(FILE *out, short buf[], int block, int shadow) {
  int line, col, i;
  short *bp, *sp;
  fprintf(out, "\n\\ *** Block No. %d, Hexblock %x\n\n", block, block);
  bp = buf +  block * BLOCKSIZE;
  sp = buf + shadow * BLOCKSIZE;
  for (line = 0, i = 0; line < 25; ++line) {
    for (col = 0; col < (line == 24 ? 40 : 41); col++, ++bp) {
      buffered_putchar(out, (char) petscii2ascii(*bp));
    }
    if (24 == line) {
      buffered_putchar(out, ' ');
    }
    buffered_putchar(out, ' ');
    buffered_putchar(out, '\\');
    buffered_putchar(out, ' ');
    for (col = 0; col < (line == 24 ? 40 : 41); col++, ++sp) {
      buffered_putchar(out, (char) petscii2ascii(*sp));
    }
    buffered_putchar(out, '\n');
  }
  return 0;
}

#define MAX_BLOCK 170
#define HALF_MAX_BLOCK (MAX_BLOCK / 2)

int readwritedisk(FILE *in, FILE *out) {
  for (int block = 0; block < MAX_BLOCK; block++)
    if (readwriteblock(in, out, block))
      return EXIT_FAILURE;
  return 0;
}

int readwritediskbuffered(FILE *in, FILE *out) {
  short buffer[MAX_BLOCK * BLOCKSIZE];
  int block;
  for (block = 0; block < MAX_BLOCK; block++)
    if (readblock(in, buffer, block))
      return EXIT_FAILURE;
  for (block = 0; block < MAX_BLOCK; block++)
    if (writeblock(out, buffer, block))
      return EXIT_FAILURE;
  return 0;
}

int readwritediskshadowed(FILE *in, FILE *out) {
  short buffer[MAX_BLOCK * BLOCKSIZE];
  int block;
  for (block = 0; block < MAX_BLOCK; block++)
    if (readblock(in, buffer, block))
      return EXIT_FAILURE;
  for (block = 0; block < HALF_MAX_BLOCK; block++)
    if (writeshadowedblock(out, buffer, block, block + HALF_MAX_BLOCK))
      return EXIT_FAILURE;
  return 0;
}

enum mode { unbufferd, buffered, shadowed };

int main(int argc, char *argv[]) {
  FILE *in, *out;
  enum mode m = unbufferd;
  if (argc >= 2 && strcmp(argv[1], "-b") == 0) {
    m = buffered;
    --argc; ++argv;
  } else if (argc >= 2 && strcmp(argv[1], "-s") == 0) {
    m = shadowed;
    --argc; ++argv;
  }
  int error = openfiles(&in, &out, argc, argv,
      "usage: %s file.d64 [outfile]\n");
  if (error) {
    return error;
  }
  switch(m) {
    case unbufferd:
      if (readwritedisk(in, out))
        return EXIT_FAILURE;
      break;
    case buffered:
      if (readwritediskbuffered(in, out))
        return EXIT_FAILURE;
      break;
    case shadowed:
      if (readwritediskshadowed(in, out))
        return EXIT_FAILURE;
      break;
    }
  return closefiles(in, out);
}

