
char s[256];

sp(int len) {
  printf("%s%d\n", s, len);
}

sprintf_test() {
  tst_chkout(tst_file_no);
INCLUDE
  tst_clrchn();

  evaluateAsserts();
}
