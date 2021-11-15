#include <lib-cio-x16.h>

#define NULL 0
#define INT_MAX 32767
#define INT_MIN -32768
#define RAND_MAX 32767

#define EOF -1

int abs(int j) {
  return ((j >= 0) ? j : -j);
}
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

char *memchr(char *s, int c, int n) {
  char *p; p = s;

  while (n--) {
    if (*p == c) {
      return p;
    }
    ++p;
  }
  return NULL;
}

int memcmp( char *s1, char *s2, int n ) {
  char * p1 = s1;
  char * p2 = s2;

  while ( n-- ) {
    if ( *p1 != *p2 ) {
      return *p1 - *p2;
    }
    ++p1;
    ++p2;
  }
  return 0;
}

char *memcpy(char *s1, char *s2, int n) {
  char * dest = s1;
  char * src = s2;

  while ( n-- ) {
    *dest++ = *src++;
  }

  return s1;
}

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

char *memset(char* s, int c, int n) {
  char *p = s;

  while (n--) {
    *p++ = c;
  }

  return s;
}

char *strcat(char *s1, char *s2) {
  char *rc = s1;

  if ( *s1 ) {
    while (*++s1) {}
  }

  while ((*s1++ = *s2++)) {}

  return rc;
}

char *strchr(char *s, int c) {
  do {
    if (*s == c) {
        return s;
    }
  } while (*s++);

  return NULL;
}

int strcmp(char *s1, char *s2) {
  while ((*s1) && (*s1 == *s2)) {
    ++s1;
    ++s2;
  }

  return (*s1 - *s2);
}

char *strcpy(char *s1, char *s2) {
  char *rc = s1;

  while ((*s1++ = *s2++)) {}

  return rc;
}

int strcspn(char *s1, char *s2) {
  int len = 0;
  char *p;

  while ( s1[len] ) {
    p = s2;

    while (*p) {
      if (s1[len] == *p++) {
          return len;
      }
    }

    ++len;
  }

  return len;
}

int strlen(char *s) {
  int rc = 0;

  while (s[rc]) {
    ++rc;
  }

  return rc;
}

char *strncat(char *s1, char *s2, int n) {
  char *rc = s1;

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

int strncmp(char *s1, char *s2, int n) {
  while (n && *s1 && (*s1 == *s2)) {
    ++s1;
    ++s2;
    --n;
  }

  if (n == 0) {
    return 0;
  }
  else {
    return (*s1 - *s2);
  }
}

char *strncpy(char *s1, char *s2, int n) {
  char *rc = s1;

  while (n && (*s1++ = *s2++)) {
    /* Note: In the original PDCLib code, n is size_t which cc64 does
       not have. */
    /* Cannot do "n--" in the conditional as size_t is unsigned and we have
       to check it again for >0 in the next loop below, so we must not risk
       underflow.
    */
    --n;
  }

  /* Checking against 1 as we missed the last --n in the loop above. */
  while (n-- > 1) {
    *s1++ = '\0';
  }

  return rc;
}

char *strpbrk(char *s1, char *s2) {
  char *p1 = s1;
  char *p2;

  while (*p1) {
    p2 = s2;

    while (*p2) {
      if (*p1 == *p2++) {
        return p1;
      }
    }

    ++p1;
  }

  return NULL;
}

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

int strspn(char *s1, char *s2) {
  int len = 0;
  char *p;

  while (s1[len]) {
    p = s2;

    while (*p) {
      if (s1[len] == *p) {
          break;
      }

      ++p;
    }

    if (! *p) {
      return len;
    }

    ++len;
  }

  return len;
}

char *strstr(char *s1, char *s2) {
  char * p1 = s1;
  char * p2;

  while (*s1) {
    p2 = s2;

    while (*p2 && (*p1 == *p2)) {
      ++p1;
      ++p2;
    }

    if (! *p2) {
      return s1;
    }

    ++s1;
    p1 = s1;
  }

  return NULL;
}
