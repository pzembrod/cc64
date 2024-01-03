
#include <rt-c64-08-9f.h>

extern _fastcall putchar() *= 0xffd2 ;

int main() {
  static int i, j;
  for (i=3;i<22;++i) {
    for (j=0;j<19;++j) {
      putchar((i+j)%6&&(i-j)%6?' ':'*');
    }
    putchar('\n');
  }
}
