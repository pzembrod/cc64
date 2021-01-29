
mult_test() {
  assertEq(0 * 0, 0, "0 * 0");
  assertEq(1 * 0, 0, "1 * 0");
  assertEq(0 * 4905, 0, "0 * 4905");
  assertEq(1 * 1, 1, "1 * 1");
  assertEq(1 * 4905, 4905, "1 * 4905");
  assertEq(9 * 7, 63, "9 * 7");
  assertEq(-9 * 8, -72, "-9 * 8");
  assertEq(-7 * -8, 56, "-7 * -8");
  assertEq(3 * -5, -15, "3 * -5");
  assertEq(123 * 234, 28782, "123 * 234");
  assertEq(128 * 128, 16384, "128 * 128");
  assertEq(128 * 256, -32768, "128 * 256");
  assertEq(128 * -256, -32768, "128 * -256");
  assertEq(-128 * -256, -32768, "-128 * -256");
  assertEq(-128 * 256, -32768, "-128 * 256");

  assertEq(noconst(0) * 0, 0, "noconst 0 * 0");
  assertEq(noconst(1) * 0, 0, "noconst 1 * 0");
  assertEq(noconst(0) * 4905, 0, "noconst 0 * 4905");
  assertEq(noconst(1) * 1, 1, "noconst 1 * 1");
  assertEq(noconst(1) * 4905, 4905, "noconst 1 * 4905");
  assertEq(noconst(9) * 7, 63, "noconst 9 * 7");
  assertEq(noconst(-9) * 8, -72, "noconst -9 * 8");
  assertEq(noconst(-7) * -8, 56, "noconst -7 * -8");
  assertEq(noconst(3) * -5, -15, "noconst 3 * -5");
  assertEq(noconst(123) * 234, 28782, "noconst 123 * 234");
  assertEq(noconst(128) * 128, 16384, "noconst 128 * 128");
  assertEq(noconst(128) * 256, -32768, "noconst 128 * 256");
  assertEq(noconst(128) * -256, -32768, "noconst 128 * -256");
  assertEq(noconst(-128) * -256, -32768, "noconst -128 * -256");
  assertEq(noconst(-128) * 256, -32768, "noconst -128 * 256");

  evaluateAsserts();
}
