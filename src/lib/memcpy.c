
char *memcpy(char *s1, char *s2, int n) {
  /* char * dest = s1;
     char * src = s2; */
  char *dest, *src;
  dest = s1;
  src = s2;

  while ( n-- ) {
    *dest++ = *src++;
  }

  return s1;
}
