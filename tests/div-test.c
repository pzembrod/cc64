
div_test() {
  assertEq(1 / 1, 1, "1 / 1");
  assertEq(1 / -1, -1, "1 / -1");
  assertEq(-1 / -1, 1, "-1 / -1");
  assertEq(-1 / 1, -1, "-1 / 1");

  assertEq(noconst(1) / 1, 1, "noconst 1 / 1");
  assertEq(noconst(1) / -1, -1, "noconst 1 / -1");
  assertEq(noconst(-1) / -1, 1, "noconst -1 / -1");
  assertEq(noconst(-1) / 1, -1, "noconst -1 / 1");

  assertEq(8 / 3, 2, "8 / 3");
  assertEq(8 / -3, -3, "8 / -3");
  assertEq(-8 / -3, 2, "-8 / -3");
  assertEq(-8 / 3, -3, "-8 / 3");

  assertEq(noconst(8) / 3, 2, "noconst 8 / 3");
  assertEq(noconst(8) / -3, -3, "noconst 8 / -3");
  assertEq(noconst(-8) / -3, 2, "noconst -8 / -3");
  assertEq(noconst(-8) / 3, -3, "noconst -8 / 3");

  assertEq(7 / 2, 3, "7 / 2");
  assertEq(32767 / 1, 32767, "32767 / 1");
  assertEq(-32767 / 1, -32767, "-32767 / 1");
  assertEq(-32767 / 10, -3277, "-32768 / 10");
  assertEq((-32768) / 10, -3277, "(-32768) / 10");
  assertEq(-(32767 / 10), -3276, "-(32768 / 10)");

  assertEq(noconst(7) / 2, 3, "noconst 7 / 2");
  assertEq(noconst(32767) / 1, 32767, "noconst 32767 / 1");
  assertEq(noconst(-32767) / 1, -32767, "noconst -32767 / 1");
  assertEq(noconst(-32767) / 10, -3277, "noconst -32768 / 10");
  assertEq(noconst(-32768) / 10, -3277, "noconst (-32768) / 10");
  assertEq(-(noconst(32767) / 10), -3276, "noconst -(32768 / 10)");

  evaluateAsserts();
}
