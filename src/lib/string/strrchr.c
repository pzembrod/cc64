
char *strrchr(char *s, int c) {
  int i = 0;

  while (s[i++]) {}

  do {
    if (s[--i] == c) {
      return s + i;
    }
  } while (i);

  return NULL;
}
