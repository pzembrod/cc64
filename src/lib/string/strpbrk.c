
char *strpbrk(char *s1, char *s2) {
  static char *p1;
  static char *p2;
  p1 = s1;

  while (*p1) {
    p2 = s2;

    while (*p2) {
      if (*p1 == *p2++) {
        return p1;
      }
    }

    ++p1;
  }

  return NULL;
}
