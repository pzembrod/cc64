
static char outfile1[] = "fopen.out1";
static char outfile2[] = "fopen.out2";
static char outfile3[] = "fopen.out3";

fopen_basic_test() {
  int fh1, fh2, fh3, c;
  static char buffer[100], *p;

  assertEq(fopen(0, 0), 0, "fopen(0, 0)");
  assertEq(fopen(0, "w"), 0, "fopen(0, \"w\")");
  assertEq(fopen("", 0), 0, "fopen(\"\", 0)");
  assertEq(fopen("", "w"), 0, "fopen(\"\", \"w\")");

  assertTrue((fh1 = fopen("libc-c16.h,s,r", 0)) != 0,
      "fopen(libc.h, 0)");
  assertEq(fh1, 7, "fh1");
  assertEq(tst_kernal_fnam_len, 14, "tst_kernal_fnam_len");
  c = fgetc(fh1);
  assertEq(c, 13, "fgetc(fh1)");
  p = fgets(buffer, 8, fh1);
  assertEq(p, buffer, "p = buffer");
  assertEq(strlen(buffer), 8, "strlen(buffer)");
  assertEq(strcmp(buffer, "#pragma "), 0,
      "strcmp(buffer, \"#pragma \")");

  assertTrue((fh2 = fopen("libc-c64.h", ",s,r")) != 0,
      "fopen(libc.h, 0)");
  assertEq(errno, 0, "errno");
  assertEq(fh2, 8, "fh1");

  assertEq(fclose(fh1), 0, "flcose(fh1)");
  c = fgetc(fh1);
  assertEq(c, -1, "fgetc(fh1) EOF");
  assertEq(errno, 3, "errno");

  assertEq(fgetc(fh2), 13, "fgetc(fh2)");
  p = fgets(buffer, 99, fh2);
  assertEq(p, buffer, "p == buffer");
  assertEq(strlen(buffer), 65, "strlen(buffer)");
  assertEq(strncmp(buffer, "#pragma ", 8), 0,
      "strncmp(buffer, \"#pragma \", 8)");
  assertEq(strcmp(buffer+56, "libc-c64\n"), 0,
      "strcmp(buffer+56, \"libc-c64\\n\")");
  assertEq(fclose(fh2), 0, "flcose(fh2)");

  remove(outfile1);

  assertTrue((fh3 = fopen(outfile1, ",s,w")) != 0,
      "fopen(outfile1, \",s,w\")");
  assertEq(fh3, 7, "fh3");
  assertEq(fputc(64, fh3), 64, "fputc(64, fh3)");
  assertEq(fputc(13, fh3), 13, "fputc(64, fh3)");
  assertEq(fputs("fputs-teststring\n", fh3), 0,
      "fputs(\"fputs-teststring\n\", fh3)");
  assertEq(fclose(fh3), 0, "flcose(fh3)");
}

fopen_copy_append_test() {
  int fh1, fh2, fh3, c;

  remove(outfile2);
  remove(outfile3);

  assertTrue((fh1 = fopen("fopen.in2", ",s,r")) != 0,
      "fopen(\"fopen.in2\", \",s,r\")");
  assertTrue((fh2 = fopen(outfile2, ",s,w")) != 0,
      "fopen(outfile2, \",s,w\")");
  assertTrue((fh3 = fopen(outfile3, ",s,w")) != 0,
      "fopen(outfile3, \",s,w\")");
  while ((c = fgetc(fh1)) != EOF) {
    assertTrue(fputc(c, fh2) != EOF, "fputc(c, fh2) != EOF");
    assertTrue(fputc(c, fh3) != EOF, "fputc(c, fh3) != EOF");
  }
  assertEq(fclose(fh1), 0, "flcose(fh1) 2nd");
  assertEq(_cc64_last_readst(fh1), 64, "_cc64_last_readst(fh1)");
  assertEq(fclose(fh2), 0, "flcose(fh2) 2nd");
  assertEq(fclose(fh3), 0, "flcose(fh3) 2nd");
}

fopen_test() {
  fopen_basic_test();
  fopen_copy_append_test();

  evaluateAsserts();
}
