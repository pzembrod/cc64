
#ifndef OPENFILES_H
#define OPENFILES_H

#include <stdio.h>

extern int openfiles(FILE **in, FILE **out, int argc, char *argv[],
    char* usageFormatStr);

#endif
