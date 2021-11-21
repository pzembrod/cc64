
printf_test() {
  tst_chkout(tst_file_no);
  printf("hello, world!\n");
  printf("foo%%bar\n", 0x41);
  printf("c:%c:\n", 0x40);
  printf("foo-%sbaz\n", "bar-");
  tst_clrchn();

  evaluateAsserts();
}
