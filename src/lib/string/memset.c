
char *memset(char* s, int c, int n) {
  char *p; p = s;

  while (n--) {
    *p++ = c;
  }

  return s;
}
