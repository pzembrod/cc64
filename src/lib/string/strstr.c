
char *strstr(char *s1, char *s2) {
  char * p1 = s1;
  char * p2;

  while (*s1) {
    p2 = s2;

    while (*p2 && (*p1 == *p2)) {
      ++p1;
      ++p2;
    }

    if (! *p2) {
      return s1;
    }

    ++s1;
    p1 = s1;
  }

  return NULL;
}
