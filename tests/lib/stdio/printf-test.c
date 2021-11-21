
printf_test() {
  tst_chkout(tst_file_no);
  printf("hello, world!\n");
  printf("foo%%bar\n", 0x41);
  printf("c:%c:\n", 0x40);
  tst_clrchn();

  evaluateAsserts();
}
