
#include "rt-c64-0801.h"
#include "kernal-io.h"

char* testOut;

name()
{
  testOut = "helloworld.out,s,w";
}

test()
{
  puts("hello, world!\n");
}

#include "test.h"
