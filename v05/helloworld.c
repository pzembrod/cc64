
#include "rt-c64-0801.h"

extern putchar() *= 0xffd2 ;

int puts(s)
char *s;
{
  while(*s != 0)
     putchar(*s++);
}

main()
{
  int i;
  for(i=1;i<=4;++i)
    {
      puts("hello, world!\n");
    }
}



