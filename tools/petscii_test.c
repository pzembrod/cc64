
#include "cheat.h"
#include "petscii.h"

CHEAT_TEST(lowercase,
  cheat_assert(petscii2ascii(0x41) == 'a');
  cheat_assert(petscii2ascii(0x5a) == 'z');
)

CHEAT_TEST(uppercase,
  cheat_assert(petscii2ascii(0x61) == 'A');
  cheat_assert(petscii2ascii(0x7a) == 'Z');
)

CHEAT_TEST(uppercase2,
  cheat_assert(petscii2ascii(0xc1) == 'A');
  cheat_assert(petscii2ascii(0xda) == 'Z');
)
