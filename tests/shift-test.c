
shift_test() {
  assertEq(1 << 0, 1, "1 << 0");
  assertEq(1 >> 0, 1, "1 >> 0");
  assertEq(-1 << 0, -1, "-1 << 0");
  assertEq(-1 >> 0, -1, "-1 >> 0");
  assertEq(1 << 1, 2, "1 << 1");
  assertEq(1 >> 1, 0, "1 >> 1");
  assertEq(-1 << 1, -2, "-1 << 1");
  assertEq(-1 >> 1, -1, "-1 >> 1");
  assertEq(2 << 1, 4, "2 << 1");
  assertEq(2 >> 1, 1, "2 >> 1");
  assertEq(-2 << 1, -4, "-2 << 1");
  assertEq(-2 >> 1, -1, "-2 >> 1");
  assertEq(10 << 5, 320, "10 << 5");
  assertEq(320 >> 5, 10, "320 >> 5");
  assertEq(-10 << 5, -320, "-10 << 5");
  assertEq(-320 >> 5, -10, "-320 >> 5");
  assertEq(1 << 14, 16384, "1 << 14");
  assertEq(-1 << 14, -16384, "-1 << 14");
  evaluateAsserts();
}
