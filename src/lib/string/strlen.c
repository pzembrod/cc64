
int strlen(char *s) {
  static int rc; rc = 0;

  while (s[rc]) {
    ++rc;
  }

  return rc;
}
