
mod_test() {
  assert(8 % 3, 2, "8 % 3");
  assert(8 % -3, -1, "8 % -3");
  assert(-8 % -3, -2, "-8 % -3");
  assert(-8 % 3, 1, "-8 % 3");

  assert(noconst(8) % 3, 2, "noconst 8 % 3");
  assert(noconst(8) % -3, -1, "noconst 8 % -3");
  assert(noconst(-8) % -3, -2, "noconst -8 % -3");
  assert(noconst(-8) % 3, 1, "noconst -8 % 3");

  assert((18) % 7, 4, " 18 % 7");
  assert((18) % -7, -3, " 18 % -7");
  assert((-18) % -7, -4, " -18 % -7");
  assert((-18) % 7, 3, " -18 % 7");

  assert(noconst(18) % 7, 4, "noconst 18 % 7");
  assert(noconst(18) % -7, -3, "noconst 18 % -7");
  assert(noconst(-18) % -7, -4, "noconst -18 % -7");
  assert(noconst(-18) % 7, 3, "noconst -18 % 7");

  assert(8 % 4, 0, "8 % 4");
  assert(8 % -4, 0, "8 % -4");
  assert(-8 % -4, 0, "-8 % -4");
  assert(-8 % 4, 0, "-8 % 4");

  assert(noconst(8) % 4, 0, "noconst 8 % 4");
  assert(noconst(8) % -4, 0, "noconst 8 % -4");
  assert(noconst(-8) % -4, 0, "noconst -8 % -4");
  assert(noconst(-8) % 4, 0, "noconst -8 % 4");

  evaluateAsserts();
}
