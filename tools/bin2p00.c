
/* file2p00.c, (c) Philip Zembrod, 2020 */

/* Converts a plain file to the P00 format. */

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
  char* filename = argv[1];
  int c;
  fputs("C64File", out); fputc(0, out);
  char* p = filename;
  while (*p) {
    fputc(ascii2petscii(*p), out);
    ++p;
  }
  for (int i = p - filename; i < 18; ++i) {
    fputc(0, out);
  }
  while ((c = fgetc(in)) != EOF) {
    fputc(c, out);
  }
  return closefiles(in, out);
}

