
isalpha_test() {
  assertTrue(isalpha('a'), "isalpha('a')");
  assertTrue(isalpha('z'), "isalpha('z')");
  assertTrue(isalpha('A'), "isalpha('A')");
  assertTrue(isalpha('Z'), "isalpha('Z')");
  assertTrue(isalpha('_'), "isalpha('_')");
  assertTrue(!isalpha(' '), "!isalpha(' ')");
  assertTrue(!isalpha('1'), "!isalpha('1')");
  assertTrue(!isalpha('@'), "!isalpha('@')");

  evaluateAsserts();
}
