
main()
{
  int i;
  _open(1,8,2, name());
  _chkout(1);
  test();
  if (failedAsserts) {
    println("Some test didn't evaluate its asserts.");
  }
  _clrchn();
  _close(1);
}
