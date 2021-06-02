
char *memset(char* s, int c, int n) {
  char *p = s;

  while (n--) {
    *p++ = c;
  }

  return s;
}
