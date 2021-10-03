
allocfh_test() {
  assertEq(_allocfh(), 7);
  assertEq(_allocfh(), 8);
  assertEq(_allocfh(), 9);
  assertEq(_allocfh(), 10);
  assertEq(_allocfh(), 11);
  assertEq(_allocfh(), 12);
  assertEq(_allocfh(), 13);
  assertEq(_allocfh(), 14);
  assertEq(_allocfh(), 0);
  assertEq(_allocfh(), 0);
  assertEq(_freefh(11), 11);
  assertEq(_allocfh(), 11);
  assertEq(_allocfh(), 0);
  assertEq(_freefh(7), 7);
  assertEq(_allocfh(), 7);
  assertEq(_allocfh(), 0);
  assertEq(_allocfh(), 0);
  assertEq(_freefh(7), 7);
  assertEq(_freefh(8), 8);
  assertEq(_freefh(9), 9);
  assertEq(_freefh(10), 10);
  assertEq(_freefh(11), 11);
  assertEq(_freefh(12), 12);
  assertEq(_freefh(13), 13);
  assertEq(_freefh(14), 14);

  evaluateAsserts();
}
