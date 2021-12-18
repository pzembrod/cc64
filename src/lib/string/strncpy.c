
char *strncpy(char *s1, char *s2, int n) {
  static char *rc; rc = s1;

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
