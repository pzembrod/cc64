
#include "rt-x16-08-9e.h"

extern _fastcall putchar() *= 0xffd2 ;

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



