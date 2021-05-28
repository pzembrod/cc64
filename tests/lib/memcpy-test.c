
#include <memcpy.c>

memcpy_test() {
  static char s[] = "xxxxxxxxxxx";
  assertEq(memcpy( s, abcde, 6 ), s, "memcpy( s, abcde, 6 )");
  assertEq(s[4], 'e', "s[4]");
  assertEq(s[5], '\0', "s[5]");
  assertEq(memcpy( s + 5, abcde, 5 ), s + 5,
      "memcpy( s + 5, abcde, 5 )");
  assertEq(s[9], 'e', "s[9]");
  assertEq(s[10], 'x', "s[10]");

  evaluateAsserts();
}
