
fgets_test() {
  int fhw, fhr, i;
  char buffer[10];
  char *fgets_test = "foo\nbar\0baz\nweenie";
  char filename[] = "fgets.tmp";

  fnunit = 8;

  assertEq(remove(filename), 0, "remove(filename)");
  
  fhw = fopen(filename, ",s,w");
  assertTrue(fhw != NULL, "fhw != NULL");
  for (i=0; i<18; ++i) {
    char c = fgets_test[i];
    assertEq(fputc(c, fhw), c, "fputc(c, fhw)");
  }
  assertEq(fclose(fhw), 0, "fclose(fhw)");

  fhr = fopen(filename, ",s,r");
  assertTrue(fhr != NULL, "fhr != NULL");

  assertEq(fgets(buffer, 10, fhr), buffer, "fgets(buffer, 10, fh)");
  assertEq(strcmp(buffer, "foo\n"), 0, "strcmp(buffer, foo)");
  assertEq(fgets(buffer, 10, fhr), buffer, "fgets(buffer, 10, fhr)");
  assertEq(memcmp(buffer, "bar\0baz\n", 8), 0,
      "memcmp(buffer, bar0baz, 8)");
  assertEq(fgets(buffer, 10, fhr), buffer, "fgets(buffer, 10, fhr)");
  assertEq(strcmp(buffer, "weenie"), 0, "strcmp(buffer, weenie)");

  assertEq(fclose(fhr), 0, "fclose(fhr)");

  evaluateAsserts();
}

