
char *strncat(char *s1, char *s2, int n) {
  static char *rc; rc = s1;

  while (*s1) {
    ++s1;
  }

  while (n && (*s1++ = *s2++)) {
    --n;
  }

  if (n == 0) {
    *s1 = '\0';
  }

  return rc;
}
