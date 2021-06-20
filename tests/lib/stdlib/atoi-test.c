
atoi_test() {
  /* basic functionality */
  assertEq(atoi("123"), 123, "atoi(\"123\")");
  /* testing skipping of leading whitespace and trailing garbage */
  assertEq(atoi(" \n\t\f456xyz"), 456, "atoi(\" \n\t\f456xyz\")");
  /* \v removed between \t and \f above as cc64 doesn't support it */

  evaluateAsserts();
}
