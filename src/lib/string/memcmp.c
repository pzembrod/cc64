
int memcmp(char *s1, char *s2, int n) {
  static char *p1;
  static char *p2;
  p1 = s1;
  p2 = s2;

  while ( n-- ) {
    if ( *p1 != *p2 ) {
      return *p1 - *p2;
    }
    ++p1;
    ++p2;
  }
  return 0;
}
