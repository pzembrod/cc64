
/* petscii2ascii.c, (c) Philip Zembrod, 2020 */

/* Converts a PETSCII file to ASCII. */

#include <stdio.h>
#include <stdlib.h>

#include "petscii.h"

    
int main(int argc, char *argv[]) {
  FILE *in, *out;
  if(argc<2 || argc>3) {
    fprintf(stderr, "usage: %s infile [outfile]\n", argv[0]);
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
  int c;
  while((c = fgetc(in)) != EOF) {
    fputc(petscii2ascii(c), out);
  }
  return(0);
}

