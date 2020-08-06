
#include "rt-c16-1001.h"

extern putc() *= 0xffd2;
/* At 0xfcaf the C16 Kernal has a rts opcode.
 * This makes for a convenient fast function that returns its parameter
 * as a non-constant value. */
extern int noconst() *= 0xfcaf;

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

extern __chkout() *= 0xffc9 ;

_chkout(lfn)
int lfn;
{ __chkout(lfn<<8); }

extern _close() *= 0xffc3 ;
extern _clrchn() *= 0xffcc ;
extern __open() *= 0xffc0 ;

extern char _kernal_fnam_len /= 0xab;
extern char _kernal_lfn /= 0xac;
extern char _kernal_sa /= 0xad;
extern char _kernal_fa /= 0xae;
extern int _kernal_fnam /= 0xaf;

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

assertTrue(expression, message)
int expression;
char *message;
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
