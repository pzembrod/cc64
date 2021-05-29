
char *memchr(char *s, int c, int n) {
  char *p; p = s;

  while (n--) {
    if (*p == c) {
      return p;
    }
    ++p;
  }
  return NULL;
}
