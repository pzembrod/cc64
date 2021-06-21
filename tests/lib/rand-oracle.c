
#include <stdlib.h>
#include <stdio.h>

unsigned int next = 1;

int myrand( void ) {
  next = next * 1103515245 + 12345;
  next &= 0xffffffff;
  return (int) (next >> 16) & 0x7fff;
}

void mysrand(int seed) {
  next = seed;
}

int main(int argc, char *argv[]) {
  int count = argc >= 2 ? atoi(argv[1]) : 5;
  if (argc >= 3) { mysrand(atoi(argv[2])); }
  char *expected = argc >= 4 ? argv[3] : "rand_expected";
  printf("int %s[] = {", expected);
  for (int i = 0; i < count - 1; ++i) {
    printf("%d, ", myrand());
  }
  printf("%d};\n", myrand());
  return 0;
}
