
add_test() {
  assertEq(0 + 0, 0, "0 + 0");
  assertEq(1 + 0, 1, "1 + 0");
  assertEq(0 + 652, 652, "0 + 652");
  assertEq(2 + 3, 5, "2 + 3");
  assertEq(16384 + 16383, 32767, "16384 + 16383");
  assertEq(32767 + -16383, 16384, "32767 + -16383");
  assertEq(32767 + 1, -32768, "32767 + 1");
  assertEq(-32768 + 1, -32767, "-32768 + 1");
  assertEq(-32768 + -1, 32767, "-32768 + -1");

  assertEq(noconst(0) + 0, 0, "noconst 0 + 0");
  assertEq(noconst(1) + 0, 1, "noconst 1 + 0");
  assertEq(noconst(0) + 652, 652, "noconst 0 + 652");
  assertEq(noconst(2) + 3, 5, "noconst 2 + 3");
  assertEq(noconst(16384) + 16383, 32767, "noconst 16384 + 16383");
  assertEq(noconst(32767) + -16383, 16384, "noconst 32767 + -16383");
  assertEq(noconst(32767) + 1, -32768, "noconst 32767 + 1");
  assertEq(noconst(-32768) + 1, -32767, "noconst -32768 + 1");
  assertEq(noconst(-32768) + -1, 32767, "noconst -32768 + -1");

  evaluateAsserts();
}
