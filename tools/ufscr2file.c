
/* ufscr2file.c, (c) Philip Zembrod, 1995, 2007, 2019, 2020 */

/* Converts a D64 disk image of a C64 ultraFORTH src screen disk
 * to an ASCII-File, in the first place for viewing, later perhaps also
 * to use as Forth src file. */

#include <stdio.h>
#include <stdlib.h>

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
      if((byte & 255) == 0) {
        sector++;
        if(sector > 20) {
          sector = 0; 
          track++;
        }
      }
    } while(skip);
  return(c);
}

void buffered_putchar(FILE *out, char c) {
  static char line[50], *p=line;
  if(p - line > 45) {
    fprintf(stderr, "!!! overlong line !!!\n");
    exit(1);
  }
  if(c == '\n') {
    while(p > line && *(p - 1) == ' ') p--;
    *p = '\0';
    fprintf(out, "%s\n", line);
    p=line;
    return;
  }
  *p++ = c;
}

int printblock(FILE *in, FILE *out, int n) {
  int line, col, c;
  fprintf(out, "\n\\ *** Block No. %d, Hexblock %x\n\n", n, n);
  for(line = 0; line < 25; line++) {
    for(col = 0; col < (line == 24 ? 40 : 41); col++) {
      c = nextchar(in);
      if(c == EOF) {
        fprintf(out, "\n### premature end of input file ###\n");
        return(1);
      }
      buffered_putchar(out, (char) petscii2ascii(c));
    }
    buffered_putchar(out, '\n');
  }
  return(0);
}
    
int main(int argc, char *argv[]) {
  FILE *in, *out;
  int block;
  if(argc<2 || argc>3) {
    fprintf(stderr, "usage: %s file.d64 [outfile]\n", argv[0]);
    return(argc!=1);
  }
  if((in=fopen(argv[1],"r"))==NULL) {
    fprintf(stderr, "%s: can't open %s\n", argv[0], argv[1]);
    return(1);
  }
  if(argc==3) {
    out = fopen(argv[2], "w");
    if(out == NULL) {
      fprintf(stderr, "%s: can't open %s\n", argv[0], argv[2]);
      return(1);
    }
  } else {
    out = stdout;
  }
  for(block = 0; block < 170; block++)
    if(printblock(in, out, block))
      return(1);
  return(0);
}

