
/* Temporary file names */
static char testfile[] = "testfile";

fopen_test() {
  /* Some of the tests are not executed for regression tests, as the libc on
     my system is at once less forgiving (segfaults on mode NULL) and more
     forgiving (accepts undefined modes).
  */
  int fh;

  remove(testfile);
  assertEq(fopen(0, 0), 0, "fopen(0, 0)");
  assertEq(fopen(0, "w"), 0, "fopen(0, \"w\")");
  assertEq(fopen("", 0), 0, "fopen(\"\", 0)");
  assertEq(fopen("", "w"), 0, "fopen(\"\", \"w\")");
  assertEq(fopen(testfile, 0), 0, "fopen(testfile, 0)");
  assertEq(fopen(testfile, ""), 0, "fopen(testfile, \"\")");

  /* assertTrue(0, "okay, this triggered"); /**/
  evaluateAsserts();
  return;
  assertEq(fopen(testfile, "wq"), 0); /* Undefined mode */
  assertEq(fopen(testfile, "wr"), 0); /* Undefined mode */
  assertTrue((fh = fopen(testfile, "w")) != 0);
  assertEq(fclose(fh), 0);
  assertEq(remove(testfile), 0);

  evaluateAsserts();
}
