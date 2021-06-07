
isalnum_test() {
  assertTrue(isalnum('a'), "isalnum('a')");
  assertTrue(isalnum('z'), "isalnum('z')");
  assertTrue(isalnum('A'), "isalnum('A')");
  assertTrue(isalnum('Z'), "isalnum('Z')");
  assertTrue(isalnum('0'), "isalnum('0')");
  assertTrue(isalnum('9'), "isalnum('9')");
  assertTrue(isalnum('_'), "isalnum('_')");
  assertTrue(!isalnum(' '), "!isalnum(' ')");
  assertTrue(!isalnum('\n'), "!isalnum('\n')");
  assertTrue(!isalnum('@'), "!isalnum('@')");

  evaluateAsserts();
}
