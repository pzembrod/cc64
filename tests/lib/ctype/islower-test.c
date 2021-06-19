
islower_test() {
  assertTrue(islower('a'), "islower('a')");
  assertTrue(islower('z'), "islower('z')");
  assertTrue(!islower('A'), "!islower('A')");
  assertTrue(!islower('Z'), "!islower('Z')");
  assertTrue(!islower(' '), "!islower(' ')");
  assertTrue(!islower('@'), "!islower('@')");
  assertTrue(!islower(0), "!islower(0)");
  assertTrue(!islower(256), "!islower(256)");

  evaluateAsserts();
}
