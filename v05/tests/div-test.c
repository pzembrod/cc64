
div_test() {
  assert(1 / 1, 1, "1 / 1");
  assert(1 / -1, -1, "1 / -1");
  assert(-1 / -1, 1, "-1 / -1");
  assert(-1 / 1, -1, "-1 / 1");

  assert(noconst(1) / 1, 1, "noconst 1 / 1");
  assert(noconst(1) / -1, -1, "noconst 1 / -1");
  assert(noconst(-1) / -1, 1, "noconst -1 / -1");
  assert(noconst(-1) / 1, -1, "noconst -1 / 1");

  assert(8 / 3, 2, "8 / 3");
  assert(8 / -3, -3, "8 / -3");
  assert(-8 / -3, 2, "-8 / -3");
  assert(-8 / 3, -3, "-8 / 3");

  assert(noconst(8) / 3, 2, "noconst 8 / 3");
  assert(noconst(8) / -3, -3, "noconst 8 / -3");
  assert(noconst(-8) / -3, 2, "noconst -8 / -3");
  assert(noconst(-8) / 3, -3, "noconst -8 / 3");

  assert(7 / 2, 3, "7 / 2");
  assert(32767 / 1, 32767, "32767 / 1");
  assert(-32767 / 1, -32767, "-32767 / 1");
  assert(-32767 / 10, -3277, "-32768 / 10");
  assert((-32768) / 10, -3277, "(-32768) / 10");
  assert(-(32767 / 10), -3276, "-(32768 / 10)");

  assert(noconst(7) / 2, 3, "noconst 7 / 2");
  assert(noconst(32767) / 1, 32767, "noconst 32767 / 1");
  assert(noconst(-32767) / 1, -32767, "noconst -32767 / 1");
  assert(noconst(-32767) / 10, -3277, "noconst -32768 / 10");
  assert(noconst(-32768) / 10, -3277, "noconst (-32768) / 10");
  assert(-(noconst(32767) / 10), -3276, "noconst -(32768 / 10)");

  evaluateAsserts();
}
