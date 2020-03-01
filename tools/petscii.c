
/* Simple petscii to ascii conversion routines. */

#include "petscii.h"

int petscii2ascii(int c) {
  if(c >= 0x41 && c <= 0x5a) return(c + 0x20);
  if(c >= 0xc0 && c <= 0xda) return(c - 0x80);
  if(c >= 0xdb && c <= 0xdf) return(c - 0x60);
  if(c < 0x20) return(0x20);
  return(c);
}
