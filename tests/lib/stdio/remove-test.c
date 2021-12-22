
remove_test() {
  char filename[] = "remove-file";

  fnunit = 8;
  assertEq(remove(filename), 0, "remove(filename), 8");

  fnunit = 7;
  assertTrue(remove(filename) != 0, "remove(filename), 7");

  fnunit = 8;

  evaluateAsserts();
}
