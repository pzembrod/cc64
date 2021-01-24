
#ifndef OPENFILES_H
#define OPENFILES_H

#include <stdio.h>

extern int openfiles(FILE **in, FILE **out, int argc, char *argv[],
    const char* usageFormatStr);

extern int closefiles(FILE *in, FILE *out);

#endif
