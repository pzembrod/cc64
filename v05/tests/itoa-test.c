
#include "itoa.h"

itoa_test()
{
  puts(itoa(13)); putc(13);
  puts(itoa(0)); putc(13);
  puts(itoa(100)); putc(13);
  puts(itoa(-12345)); putc('\n');
  puts(itoa(32767)); putc(13);
  puts(itoa(-32767)); putc(13);
  puts(itoa(-0)); putc('\n');
  puts(itoa(-32768)); putc('\n');
}
