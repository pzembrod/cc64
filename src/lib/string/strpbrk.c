
char *strpbrk(char *s1, char *s2) {
  char *p1 = s1;
  char *p2;

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
