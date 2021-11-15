
fputs_test() {
  char message[] = "SUCCESS testing fputs()\n";
  int fh;
  char filename[] = "fputs.out1";

  remove(filename);

  fh = fopen(filename, ",s,w");
  assertTrue(fh != NULL, "fopen(fputs.out1) != NULL");
  assertTrue(fputs(message, fh) >= 0, "fputs(message, fh) >= 0");
  assertEq(fclose(fh), 0, "fclose(fh)");

  evaluateAsserts();
}
