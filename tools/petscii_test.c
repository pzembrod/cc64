
#include "cheat.h"
#include "petscii.h"

CHEAT_TEST(p2a_lowercase,
  cheat_assert(petscii2ascii(0x41) == 'a');
  cheat_assert(petscii2ascii(0x5a) == 'z');
)

CHEAT_TEST(p2a_uppercase,
  cheat_assert(petscii2ascii(0x61) == 'A');
  cheat_assert(petscii2ascii(0x7a) == 'Z');
)

CHEAT_TEST(p2a_uppercase2,
  cheat_assert(petscii2ascii(0xc1) == 'A');
  cheat_assert(petscii2ascii(0xda) == 'Z');
)

CHEAT_TEST(p2a_newline,
  cheat_assert(petscii2ascii(0x0d) == 0x0a);
)

CHEAT_TEST(p2a_underscore,
  cheat_assert(petscii2ascii(0xa4) == '_');
)
