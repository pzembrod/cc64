
toupper_test() {
  assertEq(toupper('a'), 'A', "toupper('a')");
  assertEq(toupper('z'), 'Z', "toupper('z')");
  assertEq(toupper('A'), 'A', "toupper('A')");
  assertEq(toupper('Z'), 'Z', "toupper('Z')");
  assertEq(toupper('@'), '@', "toupper('@')");
  assertEq(toupper('['), '[', "toupper('[')");
  assertEq(toupper(0), 0, "toupper(0)");
  assertEq(toupper(256), 256, "toupper(256)");

  evaluateAsserts();
}
