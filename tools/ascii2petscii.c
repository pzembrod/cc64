
/* ascii2petscii.c, (c) Philip Zembrod, 2020 */

/* Converts a ASCII file to PETSCII, as needed by cc64. */

#include <stdio.h>

#include "openfiles.h"
#include "petscii.h"


int main(int argc, char *argv[]) {
  FILE *in, *out;
  int error = openfiles(&in, &out, argc, argv,
      "usage: %s infile [outfile]\n");
  if (error) {
    return error;
  }
  int c;
  while ((c = fgetc(in)) != EOF) {
    fputc(ascii2petscii(c), out);
  }
  return closefiles(in, out);
}

