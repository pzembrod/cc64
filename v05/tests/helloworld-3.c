
#include "rt-c64-0801.h"
#include "kernal-io.h"

main()
{
  int i;
  _open(1,8,2, "helloworld-3.out,s,w");
  _chkout(1);
  for(i=1;i<=3;++i)
    {
      puts("hello, world!\n");
    }
  _clrchn();
  _close(1);
}



