
abs_test() {
  assertEq(abs(0), 0, "abs(0)");
  assertEq(abs(INT_MAX), INT_MAX, "abs(INT_MAX)");
  assertEq(abs(INT_MIN + 1), -(INT_MIN + 1), "abs(INT_MIN + 1)");

  evaluateAsserts();
}
