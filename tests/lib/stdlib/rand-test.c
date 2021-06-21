
rand_test() {
  int i;
  int count = 6;
  for (i = 0; i < count; ++i) {
    assertEq(rand(), rand_expected[i], "rand() initial");
    assertTrue(rand_expected[i] < RAND_MAX,
        "rand_expected < RAND_MAX");
  }
  srand(1);
  for (i = 0; i < count; ++i) {
    assertEq(rand(), rand_expected[i], "rand() after srand(1)");
  }
  srand(17);
  for (i = 0; i < count; ++i) {
    assertEq(rand(), rand_expected_17[i], "rand() after srand(17)");
    assertTrue(rand_expected_17[i] < RAND_MAX,
        "rand_expected_17 < RAND_MAX");
  }
  srand(32767);
  for (i = 0; i < count; ++i) {
    assertEq(rand(), rand_expected_32767[i],
        "rand() after srand(32767)");
    assertTrue(rand_expected_32767[i] < RAND_MAX,
        "rand_expected_32767 < RAND_MAX");
  }
  srand(0);
  for (i = 0; i < count; ++i) {
    assertEq(rand(), rand_expected_0[i], "rand() after srand(0)");
    assertTrue(rand_expected_0[i] < RAND_MAX,
        "rand_expected_0 < RAND_MAX");
  }

  evaluateAsserts();
}
