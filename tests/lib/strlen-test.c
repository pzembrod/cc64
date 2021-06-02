
strlen_test() {
  assertEq(strlen(abcde), 5, "strlen(abcde)");
  assertEq(strlen(""), 0, "strlen(\"\")");

  evaluateAsserts();
}
