/* _PDCLIB_atomax( const char * )

   This file is part of the Public Domain C Library (PDCLib).
   Permission is granted to use, modify, and / or redistribute at will.
*/

/* #include <string.h> */
/* #include <ctype.h> */

static char _digits[] = "0123456789";
extern char *memchr();

int atoi(char *s) {
  int rc = 0;
  char sign = '+';
  char *x;

  /* TODO: In other than "C" locale, additional patterns may be defined     */
  while (isspace(*s)) {
    ++s;
  }

  if (*s == '+') {
    ++s;
  }
  else if (*s == '-') {
    sign = *(s++);
  }

  /* TODO: Earlier version was missing tolower() but was not caught by tests */
  while ((x = memchr(_digits, tolower(*(s++)), 10)) != NULL) {
    rc = rc * 10 + (x - _digits);
  }

  return (sign == '+') ? rc : -rc;
}
