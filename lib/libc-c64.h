
#pragma cc64 0xFD 0xFB 0x801 0x840 0x1AE1 0xA000 0xA000 libc-c64

#define NULL 0x0
extern char *strcat() /= 0xE9D ;
extern char *strchr() /= 0xF72 ;
extern int strcmp() /= 0xFF3 ;
extern char *strcpy() /= 0x10C8 ;
extern int strlen() /= 0x1274 ;
extern int strspn() /= 0x1859 ;
extern char *strstr() /= 0x19A4 ;
extern int strcspn() /= 0x1151 ;
extern char *strncat() /= 0x12E0 ;
extern int strncmp() /= 0x140D ;
extern char *strncpy() /= 0x1538 ;
extern char *strpbrk() /= 0x1667 ;
extern char *strrchr() /= 0x1752 ;
extern char memmove() /= 0xC45 ;
extern char *memchr() /= 0x9D1 ;
extern int memcmp() /= 0xA78 ;
extern char *memcpy() /= 0xB87 ;
extern char *memset() /= 0xE16 ;
