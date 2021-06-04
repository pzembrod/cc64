
int strlen(char *s) {
  int rc = 0;

  while (s[rc]) {
    ++rc;
  }

  return rc;
}
