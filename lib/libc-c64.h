
#pragma cc64 0xFD 0xFB 0x801 0x840 0x1B72 0xA000 0xA000 libc-c64

#define NULL 0x0
extern char *strcat() /= 0xF2E ;
extern char *strchr() /= 0x1003 ;
extern int strcmp() /= 0x1084 ;
extern char *strcpy() /= 0x1159 ;
extern int strlen() /= 0x1305 ;
extern int strspn() /= 0x18EA ;
extern char *strstr() /= 0x1A35 ;
extern int tolower() *= 0xA3C ;
extern int strcspn() /= 0x11E2 ;
extern char *strncat() /= 0x1371 ;
extern int strncmp() /= 0x149E ;
extern int toupper() *= 0xA53 ;
extern char *strncpy() /= 0x15C9 ;
extern char *strpbrk() /= 0x16F8 ;
extern char *strrchr() /= 0x17E3 ;
extern int isalpha() *= 0x9ED ;
extern int isdigit() *= 0x9D1 ;
extern int isalnum() *= 0x9DF ;
extern char memmove() /= 0xCD6 ;
extern char *memchr() /= 0xA62 ;
extern int memcmp() /= 0xB09 ;
extern char *memcpy() /= 0xC18 ;
extern char *memset() /= 0xEA7 ;
extern int islower() *= 0xA18 ;
extern int isspace() *= 0xA06 ;
extern int isupper() *= 0xA26 ;
