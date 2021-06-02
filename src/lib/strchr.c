
char *strchr(char *s, int c) {
  do {
    if (*s == c) {
        return s;
    }
  } while (*s++);

  return NULL;
}
