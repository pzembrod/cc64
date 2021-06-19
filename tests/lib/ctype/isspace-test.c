
isspace_test() {
  assertTrue(isspace(' '), "isspace(' ')");
  assertTrue(isspace('\f'), "isspace('\f')");
  assertTrue(isspace('\n'), "isspace('\n')");
  assertTrue(isspace('\r'), "isspace('\r')");
  assertTrue(isspace('\t'), "isspace('\t')");
  /* assertTrue(isspace('\v'), "isspace('\v')"); no \v in cc64 yet */
  assertTrue(!isspace('a'), "!isspace('a')");
  assertTrue(!isspace(256), "!isspace(256)");
  assertTrue(!isspace(0), "!isspace(0)");
  assertTrue(!isspace(8), "!isspace(8)");

  evaluateAsserts();
}
