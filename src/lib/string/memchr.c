
char *memchr(char *s, int c, int n) {
  static char *p; p = s;

  while (n--) {
    if (*p == c) {
      return p;
    }
    ++p;
  }
  return NULL;
}
