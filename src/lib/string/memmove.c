
char memmove(char *s1, char *s2, int n) {
  static char *dest;
  static char *src;
  dest = s1;
  src = s2;

  if (dest <= src) {
    while (n--) {
      *dest++ = *src++;
    }
  }
  else {
    src += n;
    dest += n;

    while (n--) {
      *--dest = *--src;
    }
  }

  return s1;
}
