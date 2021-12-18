
char *memcpy(char *s1, char *s2, int n) {
  static char *dest;
  static char *src;
  dest = s1;
  src = s2;

  while ( n-- ) {
    *dest++ = *src++;
  }

  return s1;
}
