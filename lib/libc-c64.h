
#pragma cc64 0xFD 0xFB 0x801 0x840 0x1B16 0xA000 0xA000 libc-c64

#define NULL 0x0
extern char *strcat() /= 0xED2 ;
extern char *strchr() /= 0xFA7 ;
extern int strcmp() /= 0x1028 ;
extern char *strcpy() /= 0x10FD ;
extern int strlen() /= 0x12A9 ;
extern int strspn() /= 0x188E ;
extern char *strstr() /= 0x19D9 ;
extern int strcspn() /= 0x1186 ;
extern char *strncat() /= 0x1315 ;
extern int strncmp() /= 0x1442 ;
extern char *strncpy() /= 0x156D ;
extern char *strpbrk() /= 0x169C ;
extern char *strrchr() /= 0x1787 ;
extern int isalpha() *= 0x9ED ;
extern int isdigit() *= 0x9D1 ;
extern int isalnum() *= 0x9DF ;
extern char memmove() /= 0xC7A ;
extern char *memchr() /= 0xA06 ;
extern int memcmp() /= 0xAAD ;
extern char *memcpy() /= 0xBBC ;
extern char *memset() /= 0xE4B ;
