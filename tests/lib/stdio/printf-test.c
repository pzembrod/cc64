
printf_test() {
  tst_chkout(tst_file_no);
  printf("hello, world!\n");
  printf("foo%%bar\n", 0x41);
  printf("c:%c:\n", 0x40);
  printf("foo-%sbaz\n", "bar-");
  printf("%s = $%x\n", "cold start", 64738);
  printf("%s %s = $%x\n", "tape", "buffer", 828);
  printf("asc('(') = $%x asc(CR) = $%x\n", '(', '\n');
  printf("12345 = %d ; ten = %d ; two = %d ; zero = %d\n",
      12345, 10, 2, 0);
  tst_clrchn();

  evaluateAsserts();
}
