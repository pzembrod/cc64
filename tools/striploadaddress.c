
/* striploadaddress.c, (c) Philip Zembrod, 2020 */

/* Strips the first 2 bytes from a file. */

#include <stdio.h>

#include "openfiles.h"
#include "petscii.h"

    
int main(int argc, char *argv[]) {
  FILE *in, *out;
  int error = openfiles(&in, &out, argc, argv,
      "usage: %s infile [outfile]\n");
  if (error) {
    return(error);
  }
  int c;
  if (fgetc(in) == EOF) return 1;
  if (fgetc(in) == EOF) return 1;
  while((c = fgetc(in)) != EOF) {
    fputc(c, out);
  }
  return(0);
}

