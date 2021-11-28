  P(PRINTF("hello, world!\n"));
  P(PRINTF("foo%%bar\n", 0x41));
  P(PRINTF("c:%c:\n", 0x40));
  P(PRINTF("foo-%sbaz\n", "bar-"));
  P(PRINTF("%s = $%x\n", "cold start", 64738));
  P(PRINTF("%s %s = $%x\n", "tape", "buffer", 828));
  P(PRINTF("asc('(') = $%x asc(CR) = $%x\n", '(', '\n'));
  P(PRINTF("4 digit %s = $%x\n", "cold start", 64738));
  P(PRINTF("4 digit %s %s = $%04x\n", "tape", "buffer", 828));
  P(PRINTF("2 digit asc('(') = $%02x asc(CR) = $%02x\n", '(', '\n'));
  P(PRINTF("Upper case 2-4 digit: $%X $%04X $%03X $%X $%02X\n",
      64738, 828, 255, 65535, 13));
  P(PRINTF("12345 = %d ; ten = %d ; two = %d ; zero = %d\n",
      12345, 10, 2, 0));
  P(PRINTF("12345: '%9d' ten: '%3d' two: '%2d' zero: '%5d'\n",
      12345, 10, 2, 0));
  P(PRINTF("23456: '%10d' ten: '%11d' two: '%19d'\n",
      23456, 10, 2));
  P(PRINTF("-12345: '%9d' -10: '%4d' -2: '%3d' -1: '%5d'\n",
      -12345, -10, -2, -1));
  P(PRINTF("12345: '%09d' ten: '%03d' two: '%02d' zero: '%05d'\n",
      12345, 10, 2, 0));
  P(PRINTF("-00012345: '%09d' -010: '%04d' -02: '%03d' -0001: '%05d'\n",
      -12345, -10, -2, -1)); /* */
  P(PRINTF("0x8000 = (%%u) %u = (%%d) %d\n", 0x8000, 0x8000));
  P(PRINTF("0x7fff = (%%u) %u = (%%d) %d\n", 0x7fff, 0x7fff));
  P(PRINTF("0xffff = (%%u) %u = (%%d) %d\n", 0xffff, 0xffff));
  P(PRINTF("%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18));
  P(PRINTF("%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x\n",
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18));
