
allocfh_test() {
  assertEq(allocfh(), 7);
  assertEq(allocfh(), 8);
  assertEq(allocfh(), 9);
  assertEq(allocfh(), 10);
  assertEq(allocfh(), 11);
  assertEq(allocfh(), 12);
  assertEq(allocfh(), 13);
  assertEq(allocfh(), 14);
  assertEq(allocfh(), 0);
  assertEq(allocfh(), 0);
  assertEq(freefh(11), 11);
  assertEq(allocfh(), 11);
  assertEq(allocfh(), 0);
  assertEq(freefh(7), 7);
  assertEq(allocfh(), 7);
  assertEq(allocfh(), 0);
  assertEq(allocfh(), 0);
  assertEq(freefh(7), 7);
  assertEq(freefh(8), 8);
  assertEq(freefh(9), 9);
  assertEq(freefh(10), 10);
  assertEq(freefh(11), 11);
  assertEq(freefh(12), 12);
  assertEq(freefh(13), 13);
  assertEq(freefh(14), 14);

  evaluateAsserts();
}
