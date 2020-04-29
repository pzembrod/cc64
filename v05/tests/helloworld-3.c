
#include "rt-c64-0801.h"
#include "kernal-io.h"

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
  open(1,8,2, "helloworld-3.out,s,w");
  _chkout(1);
  for(i=1;i<=3;++i)
    {
      puts("hello, world!\n");
    }
  _clrchn();
  _close(1);
}



