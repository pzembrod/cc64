
int strcspn(char *s1, char *s2) {
  static int len;
  static char *p;
  len = 0;

  while ( s1[len] ) {
    p = s2;

    while (*p) {
      if (s1[len] == *p++) {
          return len;
      }
    }

    ++len;
  }

  return len;
}
