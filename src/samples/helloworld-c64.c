
#include "rt-c64-08-9f.h"

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



