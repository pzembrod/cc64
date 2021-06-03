#include "rt-c64-08-9f.h"

extern putc() *= 0xffd2;

print(s)
char *s;
{
  while(*s != 0)
     putc(*s++);
}

println(s)
char *s;
{
  print(s); putc('\n');
}

char* itoa(i)
int i;
{
  static char buffer[10];
  int n, d;
  if (i == -32768)
    return "-32768";
  n = 0;
  if (i < 0) {
    buffer[n++] = '-';
    i = -i;
  }
  if (i == 0) {
    buffer[n++] = '0';
  } else {
    d = 10000;
    while (d > i) { d /= 10; }
    while (d) {
      buffer[n++] = '0' + (i / d);
      i %= d;
      d /= 10;
    }
  }
  buffer[n] = 0;
  return buffer;
}

#define MAX 8191

main() {
  static char flag[MAX];
  static int i, j, count, prime;
  for (i=1; i<MAX; ++i) {
    flag[i] = 1;
  }
  count = 0;
  for (i=1; i<MAX; ++i) {
    if (flag[i]) {
      prime = (i<<1) + 1;
      /* print(itoa(prime)); print(" "); /* */
      for (j=i+prime; j<MAX; j+=prime) {
        flag[j] = 0;
      }
      ++count;
    }
  }
  println("");
  print(itoa(count));
  print(" primes\n");
}
