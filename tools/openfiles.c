
#include <errno.h>
#include <stdlib.h>

#include "openfiles.h"

int openfiles(FILE **in, FILE **out, int argc, char *argv[],
    char* usageFormatStr) {
  if(argc<2 || argc>3) {
    fprintf(stderr, usageFormatStr, argv[0]);
    return argc==1 ? EXIT_SUCCESS : EXIT_FAILURE;
  }
  if (argv[1][0] == '-' && argv[1][1] == 0) {
    *in = stdin;
  } else if ((*in=fopen(argv[1],"r"))==NULL) {
    fprintf(stderr, "%s: can't open %s. Errno = %d\n",
        argv[0], argv[1], errno);
    return EXIT_FAILURE;
  }
  if (argc==3) {
    *out = fopen(argv[2], "w");
    if(*out == NULL) {
      fprintf(stderr, "%s: can't open %s. Errno = %d\n",
          argv[0], argv[2], errno);
      return 1;
    }
  } else {
    *out = stdout;
  }
  return EXIT_SUCCESS;
}

int closefiles(FILE *in, FILE *out) {
  int result = EXIT_SUCCESS;
  if (out != stdout) {
    if (fclose(out)) {
      fprintf(stderr, "Errno %d closing outfile\n", errno);
      result = EXIT_FAILURE;
    }
  }
  if (in  != stdin) {
    if (fclose(in)) {
      fprintf(stderr, "Errno %d closing infile\n", errno);
      result = EXIT_FAILURE;
    }
  }
  return result;
}
