
puts_test() {
  tst_chkout(tst_file_no);

  assertTrue(puts("Hello, World!\n") >= 0, "puts(Hello, Wolrd!)");
  assertEq(puts(NULL), EOF, "puts(NULL)");
  assertTrue(puts("1234") >= 0, "puts(1234)");
  assertTrue(puts("5678\n") >= 0, "puts(5678)");

  tst_clrchn();

  evaluateAsserts();
}
