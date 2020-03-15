
#include "openfiles.h"

int openfiles(FILE **in, FILE **out, int argc, char *argv[],
    char* usageFormatStr) {
  if(argc<2 || argc>3) {
    fprintf(stderr, "usage: %s infile [outfile]\n", argv[0]);
    return(argc!=1);
  }
  if((*in=fopen(argv[1],"r"))==NULL) {
    fprintf(stderr, "%s: can't open %s\n", argv[0], argv[1]);
    return(1);
  }
  if(argc==3) {
    *out = fopen(argv[2], "w");
    if(*out == NULL) {
      fprintf(stderr, "%s: can't open %s\n", argv[0], argv[2]);
      return(1);
    }
  } else {
    *out = stdout;
  }
  return 0;
}
