
#include "rt-x16-08-9e.h"

extern _fastcall putc() *= 0xffd2;

int noconst(i)
int i;
{ return i; }

print(char *s)
{
  while(*s != 0)
     putc(*s++);
}

println(s)
char *s;
{
  print(s); putc('\n');
}

extern _fastcall __chkout() *= 0xffc9 ;

_chkout(int lfn)
{ __chkout(lfn<<8); }

extern _fastcall _close() *= 0xffc3 ;
extern _fastcall _clrchn() *= 0xffcc ;
extern _fastcall __open() *= 0xffc0 ;

extern char _kernal_fnam_len *= 0x28e;
extern char _kernal_lfn *= 0x28f;
extern char _kernal_sa *= 0x290;
extern char _kernal_fa *= 0x291;
extern int _kernal_fnam *= 0x8c;

_open(lfn, fa, sa, fnam)
char lfn, fa, sa;
char *fnam;
{
  char *p;
  for(p=fnam; *p; ++p);
  _kernal_fnam_len = p-fnam;
  _kernal_lfn = lfn;
  _kernal_fa = fa;
  _kernal_sa = sa;
  _kernal_fnam = fnam;
  __open();
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

int failedAsserts = 0;

assertEq(actual, expected, message)
int actual;
int expected;
char *message;
{
  if (actual != expected) {
    print("Assert failed: "); print(message);
    print(" Expected: "); print(itoa(expected));
    print(" Actual: "); println(itoa(actual));
    ++failedAsserts;
  }
}

assertTrue(int expression, char *message)
{
  if (!expression) {
    print("Assert failed: "); println(message);
    ++failedAsserts;
  }
}

evaluateAsserts() {
  if (failedAsserts) {
    print(itoa(failedAsserts));
    println(" assert(s) failed.");
  } else {
    println("No assert failed.");
  }
  failedAsserts = 0;
}
