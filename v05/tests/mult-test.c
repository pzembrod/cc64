
mult_test() {
  assert(0 * 0, 0, "0 * 0");
  assert(1 * 0, 0, "1 * 0");
  assert(0 * 4905, 0, "0 * 4905");
  assert(1 * 1, 1, "1 * 1");
  assert(1 * 4905, 4905, "1 * 4905");
  assert(9 * 7, 63, "9 * 7");
  assert(-9 * 8, -72, "-9 * 8");
  assert(-7 * -8, 56, "-7 * -8");
  assert(3 * -5, -15, "3 * -5");
  assert(123 * 234, 28782, "123 * 234");
  assert(128 * 128, 16384, "128 * 128");
  assert(128 * 256, -32768, "128 * 256");
  assert(128 * -256, -32768, "128 * -256");
  assert(-128 * -256, -32768, "-128 * -256");
  assert(-128 * 256, -32768, "-128 * 256");

  assert(noconst(0) * 0, 0, "0 * 0");
  assert(noconst(1) * 0, 0, "1 * 0");
  assert(noconst(0) * 4905, 0, "0 * 4905");
  assert(noconst(1) * 1, 1, "1 * 1");
  assert(noconst(1) * 4905, 4905, "1 * 4905");
  assert(noconst(9) * 7, 63, "9 * 7");
  assert(noconst(-9) * 8, -72, "-9 * 8");
  assert(noconst(-7) * -8, 56, "-7 * -8");
  assert(noconst(3) * -5, -15, "3 * -5");
  assert(noconst(123) * 234, 28782, "123 * 234");
  assert(noconst(128) * 128, 16384, "128 * 128");
  assert(noconst(128) * 256, -32768, "128 * 256");
  assert(noconst(128) * -256, -32768, "128 * -256");
  assert(noconst(-128) * -256, -32768, "-128 * -256");
  assert(noconst(-128) * 256, -32768, "-128 * 256");

  evaluateAsserts();
}
