
#include <rt-c16-10-7f.h>

extern _fastcall putchar() *= 0xffd2 ;

int main() {
  static int i, j, x, y, dx, dy;
  for (i=0, y=3, dy=1; i<19; ++i, y+=dy) {
    dy=(y==0?1:y==3?-1:dy);
    for (j=0, x=0, dx=1; j<19; ++j, x+=dx) {
      dx=(x==0?1:x==3?-1:dx);
      putchar(x==y?'*':' ');
    }
    putchar('\n');
  }
}
