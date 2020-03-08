
/* Simple petscii to ascii conversion routines. */

#include "petscii.h"

int ascii2petscii(int c) {
  if(c >= 0x41 && c <= 0x5a) return(c + 0x80);
  if(c >= 0x61 && c <= 0x7a) return(c - 0x20);
  if(c >= 0x7b && c <= 0x7f) return(c + 0x60);
  if(c == 0x0a) return(0x0d);
  if(c == '_') return(0xa4);
  if(c < 0x20) return(0x20);
  return(c);
}

int petscii2ascii(int c) {
  if(c >= 0x41 && c <= 0x5a) return(c + 0x20);
  if(c >= 0x61 && c <= 0x7a) return(c - 0x20);
  if(c >= 0xc0 && c <= 0xda) return(c - 0x80);
  if(c >= 0xdb && c <= 0xdf) return(c - 0x60);
  if(c == 0x0d) return(0x0a);
  if(c == 0xa4) return('_');
  if(c < 0x20) return(0x20);
  return(c);
}
