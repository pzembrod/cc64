
printf_test() {
  tst_chkout(tst_file_no);
  assertEq(printf("hello, world!\n"), 14, "hello, world");
  printf("foo%%bar\n", 0x41);
  printf("c:%c:\n", 0x40);
  printf("foo-%sbaz\n", "bar-");
  printf("%s = $%x\n", "cold start", 64738);
  printf("%s %s = $%x\n", "tape", "buffer", 828);
  printf("asc('(') = $%x asc(CR) = $%x\n", '(', '\n');
  printf("4 digit %s = $%x\n", "cold start", 64738);
  printf("4 digit %s %s = $%04x\n", "tape", "buffer", 828);
  printf("2 digit asc('(') = $%02x asc(CR) = $%02x\n", '(', '\n');
  printf("Upper case 2-4 digit: $%X $%04X $%03X $%X $%02X\n",
      64738, 828, 255, 65535, 13);
  printf("12345 = %d ; ten = %d ; two = %d ; zero = %d\n",
      12345, 10, 2, 0);
  printf("12345: '%9d' ten: '%3d' two: '%2d' zero: '%5d'\n",
      12345, 10, 2, 0);
  printf("23456: '%10d' ten: '%11d' two: '%19d'\n",
      23456, 10, 2);
  printf("-12345: '%9d' -10: '%4d' -2: '%3d' -1: '%5d'\n",
      -12345, -10, -2, -1);
  printf("12345: '%09d' ten: '%03d' two: '%02d' zero: '%05d'\n",
      12345, 10, 2, 0);
  printf("-00012345: '%09d' -010: '%04d' -02: '%03d' -0001: '%05d'\n",
      -12345, -10, -2, -1); /* */
  printf("0x8000 = %u = %d\n", 0x8000, 0x8000);
  tst_clrchn();

  evaluateAsserts();
}
