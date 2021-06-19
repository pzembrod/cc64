
main()
{
  int i;
  tst_open(1,8,2, name());
  tst_chkout(1);
  test();
  if (failedAsserts) {
    tst_println("Some test didn't evaluate its asserts.");
  }
  tst_clrchn();
  tst_close(1);
}
