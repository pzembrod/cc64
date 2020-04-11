
/* file2t64.c, (c) Philip Zembrod, 2020 */

/* Creates a t64 tape image from a c64 prg file. */

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
  char* filename = argv[1];
  char filebytes[65538];
  char* readptr = filebytes;
  char* writeptr = filebytes;
  int c;
  // Read file content
  while((c = fgetc(in)) != EOF) {
    *readptr++ = (char) c;
  }
  if(readptr - writeptr < 2) {
    fprintf(stderr, "file size %ld\n", readptr - writeptr);
    return(1);
  }

  // T64 Tape Record
  fputs("C64S tape image file", out);
  for(int i = 0; i < 12; ++i) {
    fputc(0, out);
  }
  fputc(0, out); fputc(2, out);  // T64 version
  fputc(1, out); fputc(0, out);  // max # of dir entries
  fputc(1, out); fputc(0, out);  // # of used dir entries
  fputc(0, out); fputc(0, out);  // unused
  char* p = filename;
  while(*p) {
    fputc(*p, out);
    ++p;
  }
  for(int i = p - filename; i < 24; ++i) {
    fputc(0x20, out);
  }

  // T64 File Record
  fputc(1, out);  // C64s file type: 1 = normap tape file
  fputc(1, out);  // C64 file type: 1 = program file
  int startLo = *writeptr++;
  int startHi = *writeptr++;
  int startAddr = startLo + (startHi << 8);
  int endAddr = startAddr + readptr - writeptr;
  fputc(startLo, out);
  fputc(startHi, out);
  fputc(endAddr & 0xff, out);
  fputc(endAddr >> 8, out);
  fputc(0, out); fputc(0, out);  // unused
  fputc(0x60, out); fputc(0, out);  // offset lo word
  fputc(0, out); fputc(0, out);  // offset hi word
  fputc(0, out); fputc(0, out);  // unused
  fputc(0, out); fputc(0, out);  // unused
  p = filename;
  while(*p) {
    fputc(ascii2petscii(*p), out);
    ++p;
  }
  for(int i = p - filename; i < 16; ++i) {
    fputc(0x20, out);
  }
  
  while(writeptr < readptr) {
    fputc(*writeptr++, out);
  }
  return(0);
}

