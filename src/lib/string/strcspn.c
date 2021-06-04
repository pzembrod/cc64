
int strcspn(char *s1, char *s2) {
  int len = 0;
  char *p;

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
