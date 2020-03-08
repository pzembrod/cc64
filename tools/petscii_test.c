
#include "cheat.h"
#include "petscii.h"

CHEAT_TEST(a2p_lowercase,
  cheat_assert(ascii2petscii('a') == 0x41);
  cheat_assert(ascii2petscii('z') == 0x5a);
)

CHEAT_TEST(a2p_uppercase,
  cheat_assert(ascii2petscii('A') == 0xc1);
  cheat_assert(ascii2petscii('Z') == 0xda);
)

CHEAT_TEST(a2p_digits,
  cheat_assert(ascii2petscii('0') == '0');
  cheat_assert(ascii2petscii('9') == '9');
)

CHEAT_TEST(a2p_newline,
  cheat_assert(ascii2petscii(0x0a) == 0x0d);
)

// TODO: Figure out what role underscore plays in the cc64 Forth
// sources. There 0xa4 seems to be used as underscore.
CHEAT_TEST(a2p_underscore,
  cheat_assert(ascii2petscii('_') == '_');
)


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

CHEAT_TEST(p2a_digits,
  cheat_assert(petscii2ascii('0') == '0');
  cheat_assert(petscii2ascii('9') == '9');
)

CHEAT_TEST(p2a_newline,
  cheat_assert(petscii2ascii(0x0d) == 0x0a);
)

CHEAT_TEST(p2a_underscore,
  cheat_assert(petscii2ascii(0xa4) == '_');
)
