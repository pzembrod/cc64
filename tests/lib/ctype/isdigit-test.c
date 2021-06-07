
isdigit_test() {
  assertTrue(isdigit('0'), "isdigit('0')");
  assertTrue(isdigit('9'), "isdigit('9')");
  assertTrue(!isdigit(' '), "!isdigit(' ')");
  assertTrue(!isdigit('a'), "!isdigit('a')");
  assertTrue(!isdigit('@'), "!isdigit('@')");

  evaluateAsserts();
}
