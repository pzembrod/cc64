
/* Temporary file names */
static char testfile[] = "testfile";

fopen_test() {
  /* Some of the tests are not executed for regression tests, as the libc on
     my system is at once less forgiving (segfaults on mode NULL) and more
     forgiving (accepts undefined modes).
  */
  int fh, c;
  static char buffer[100], *p;

  remove(testfile);
  assertEq(fopen(0, 0), 0, "fopen(0, 0)");
  assertEq(fopen(0, "w"), 0, "fopen(0, \"w\")");
  assertEq(fopen("", 0), 0, "fopen(\"\", 0)");
  assertEq(fopen("", "w"), 0, "fopen(\"\", \"w\")");

  assertTrue((fh = fopen("libc-c64.h,s,r", 0)) != 0,
      "fopen(libc.h, 0)");
  assertEq(fh, 7, "fh");
  assertEq(tst_kernal_fnam_len, 14, "tst_kernal_fnam_len");
  c = fgetc(fh);
  assertEq(c, 13, "fgetc(fh)");
  p = fgets(buffer, 8, fh);
  assertEq(p, buffer, "p = buffer");
  assertEq(strlen(buffer), 8, "strlen(buffer)");
  assertEq(strcmp(buffer, "#pragma "), 0,
      "strcmp(buffer, \"#pragma \")");
  assertEq(fclose(fh), 0, "flcose(fh)");
  c = fgetc(fh);
  assertEq(c, -1, "fgetc(fh) EOF");
  assertEq(errno, 3, "errno");

  evaluateAsserts();
  return;

  assertTrue((fh = fopen(testfile, "2")) != 0, "fopen(testfile, \"\")");
  assertEq(fh, 8, "fh");
  assertEq(tst_kernal_fnam_len, 9, "tst_kernal_fnam_len");
  assertEq(strncmp(tst_kernal_fnam, "testfile2", 9), 0,
      "strncmp(tst_kernal_fnam, testfile1)");

  assertTrue((fh = fopen(testfile, ",s,w")) != 0,
      "fopen(testfile, \",s,w\")");
  assertEq(fh, 9, "fh");
  assertEq(tst_kernal_fnam_len, 12, "tst_kernal_fnam_len");
  assertEq(strncmp(tst_kernal_fnam, "testfile,s,w", 12), 0,
      "strncmp(tst_kernal_fnam, testfile,s,w)");

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
