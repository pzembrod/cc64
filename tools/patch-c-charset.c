
/* patch-c-charset.c, (c) Philip Zembrod, 2021 */

/* Patches cc64's C chars into a CBM charset rom. */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "openfiles.h"

#define CHARBLOCKSIZE 1024

const unsigned char patchlist[] = {
  0x1c,
  0b00000000,
  0b01100000,
  0b00110000,
  0b00011000,
  0b00001100,
  0b00000110,
  0b00000011,
  0b00000000,

  0x1e,
  0b00000000,
  0b00011000,
  0b00111100,
  0b01100110,
  0b00000000,
  0b00000000,
  0b00000000,
  0b00000000,

  0x1f,
  0b00000000,
  0b00000000,
  0b00000000,
  0b00000000,
  0b00000000,
  0b00000000,
  0b00000000,
  0b11111111,

  0x5b,
  0b00001100,
  0b00011000,
  0b00011000,
  0b00110000,
  0b00011000,
  0b00011000,
  0b00001100,
  0b00000000,

  0x5c,
  0b00011000,
  0b00011000,
  0b00011000,
  0b00000000,
  0b00011000,
  0b00011000,
  0b00011000,
  0b00000000,

  0x5d,
  0b00110000,
  0b00011000,
  0b00011000,
  0b00001100,
  0b00011000,
  0b00011000,
  0b00110000,
  0b00000000,

  0x5e,
  0b00000000,
  0b00110010,
  0b01111110,
  0b01001100,
  0b00000000,
  0b00000000,
  0b00000000,
  0b00000000,

  0x20
};

int patchcharblock(unsigned char buffer[], size_t size,
    unsigned char xormask) {
  const unsigned char *p = patchlist;
  while (0x20 != *p) {
    int screen_code = *p++;
    size_t index = screen_code << 3;
    for (int line = 0; line < 8; ++line, ++index, ++p) {
      if (index >= size) {
        fprintf(stderr,
            "index %lu for screen code %u out of buffer size %lu\n",
            index, screen_code, size);
        return 1;
      }
      buffer[index] = *p ^ xormask;
    }
  }
  return 0;
}

int readcharblock(FILE *in, unsigned char buffer[], size_t size) {
  for (int i=0; i<size; ++i) {
    int c = fgetc(in);
    if (EOF == c) {
      return 1;
    }
    buffer[i] = c;
  }
  return 0;
}

int writecharblock(FILE *out, unsigned char buffer[], size_t size) {
  for (int i=0; i<size; ++i) {
    int c = fputc(buffer[i], out);
    if (EOF == c) {
      return 1;
    }
  }
  return 0;
}

int main(int argc, char *argv[]) {
  int opt;
  long normal_offset, inverse_offset;
  char* endptr;
  const char* usageFormatStr = "usage: %s [-n normal-offset] "
      "[-i inverse-offset] infile [outfile]\n";
  normal_offset = -1;
  inverse_offset = -1;
  while ((opt = getopt(argc, argv, "n:i:")) != -1) {
     switch (opt) {
     case 'n':
         normal_offset = strtoul(optarg, &endptr, 10);
         if (*endptr) {
           fprintf(stderr, "can't convert %s to long\n", optarg);
           return EXIT_FAILURE;
         }
         break;
     case 'i':
         inverse_offset = strtoul(optarg, &endptr, 10);
         if (*endptr) {
           fprintf(stderr, "can't convert %s to long\n", optarg);
           return EXIT_FAILURE;
         }
         break;
     default: /* '?' */
         fprintf(stderr, usageFormatStr, argv[0]);
         return EXIT_FAILURE;
     }
  }
  // fprintf(stderr, "optind = %d\n", optind);
  --optind;
  FILE *in, *out;
  int error = openfiles(&in, &out, argc - optind, argv + optind,
      usageFormatStr);
  if (error) {
    return EXIT_FAILURE;
  }
  int c;
  long offset = 0;
  unsigned char buffer[CHARBLOCKSIZE];
  while (1) {
    if (offset == normal_offset || offset == inverse_offset) {
      error = readcharblock(in, buffer, CHARBLOCKSIZE);
      if (error) {
        return EXIT_FAILURE;
      }
      error = patchcharblock(buffer, CHARBLOCKSIZE,
          offset == inverse_offset ? 0xff : 0);
      if (error) {
        return EXIT_FAILURE;
      }
      error = writecharblock(out, buffer, CHARBLOCKSIZE);
      if (error) {
        return EXIT_FAILURE;
      }
      offset += CHARBLOCKSIZE;
    } else {
      c = fgetc(in);
      if (EOF == c) break;
      fputc(c, out);
      ++offset;
    }
  }
  return closefiles(in, out);
}

