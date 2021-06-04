
char memmove(char *s1, char *s2, int n) {
  char *dest = s1;
  char *src = s2;

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
