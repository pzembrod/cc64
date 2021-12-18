
char *strcpy(char *s1, char *s2) {
  static char *rc; rc = s1;

  while ((*s1++ = *s2++)) {}

  return rc;
}
