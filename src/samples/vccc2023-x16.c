
#include "rt-x16-08-9e.h"

extern _fastcall putchar() *= 0xffd2 ;

int main() {
  static int j;
  for (j=0;j<380;++j)
    putchar(j%20-19?(j/20+j%20+3)%6&&(j/20-j%20+3)%6?' ':'*':'\n');
}
