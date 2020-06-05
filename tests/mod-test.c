
mod_test() {
  assertEq(8 % 3, 2, "8 % 3");
  assertEq(8 % -3, -1, "8 % -3");
  assertEq(-8 % -3, -2, "-8 % -3");
  assertEq(-8 % 3, 1, "-8 % 3");

  assertEq(noconst(8) % 3, 2, "noconst 8 % 3");
  assertEq(noconst(8) % -3, -1, "noconst 8 % -3");
  assertEq(noconst(-8) % -3, -2, "noconst -8 % -3");
  assertEq(noconst(-8) % 3, 1, "noconst -8 % 3");

  assertEq((18) % 7, 4, " 18 % 7");
  assertEq((18) % -7, -3, " 18 % -7");
  assertEq((-18) % -7, -4, " -18 % -7");
  assertEq((-18) % 7, 3, " -18 % 7");

  assertEq(noconst(18) % 7, 4, "noconst 18 % 7");
  assertEq(noconst(18) % -7, -3, "noconst 18 % -7");
  assertEq(noconst(-18) % -7, -4, "noconst -18 % -7");
  assertEq(noconst(-18) % 7, 3, "noconst -18 % 7");

  assertEq(8 % 4, 0, "8 % 4");
  assertEq(8 % -4, 0, "8 % -4");
  assertEq(-8 % -4, 0, "-8 % -4");
  assertEq(-8 % 4, 0, "-8 % 4");

  assertEq(noconst(8) % 4, 0, "noconst 8 % 4");
  assertEq(noconst(8) % -4, 0, "noconst 8 % -4");
  assertEq(noconst(-8) % -4, 0, "noconst -8 % -4");
  assertEq(noconst(-8) % 4, 0, "noconst -8 % 4");

  evaluateAsserts();
}
