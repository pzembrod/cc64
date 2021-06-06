
#pragma cc64 0x40 0x42 0x801 0x83D 0x1B13 0x9F00 0x9F00 libc-x16

#define NULL 0x0
extern char *strcat() /= 0xECF ;
extern char *strchr() /= 0xFA4 ;
extern int strcmp() /= 0x1025 ;
extern char *strcpy() /= 0x10FA ;
extern int strlen() /= 0x12A6 ;
extern int strspn() /= 0x188B ;
extern char *strstr() /= 0x19D6 ;
extern int strcspn() /= 0x1183 ;
extern char *strncat() /= 0x1312 ;
extern int strncmp() /= 0x143F ;
extern char *strncpy() /= 0x156A ;
extern char *strpbrk() /= 0x1699 ;
extern char *strrchr() /= 0x1784 ;
extern int isalpha() *= 0x9EA ;
extern int isdigit() *= 0x9CE ;
extern int isalnum() *= 0x9DC ;
extern char memmove() /= 0xC77 ;
extern char *memchr() /= 0xA03 ;
extern int memcmp() /= 0xAAA ;
extern char *memcpy() /= 0xBB9 ;
extern char *memset() /= 0xE48 ;
