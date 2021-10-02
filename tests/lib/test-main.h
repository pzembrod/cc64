
main()
{
  int i;
  tst_open(tst_file_no, 8, 2, name());
  test();
  if (failedAsserts) {
    tst_println("Some test didn't evaluate its asserts.");
  }
  tst_close(tst_file_no);
}
