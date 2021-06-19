
#pragma cc64 0x40 0x42 0x801 0x83D 0x1B6F 0x9F00 0x9F00 libc-x16

#define NULL 0x0
extern char *strcat() /= 0xF2B ;
extern char *strchr() /= 0x1000 ;
extern int strcmp() /= 0x1081 ;
extern char *strcpy() /= 0x1156 ;
extern int strlen() /= 0x1302 ;
extern int strspn() /= 0x18E7 ;
extern char *strstr() /= 0x1A32 ;
extern int tolower() *= 0xA39 ;
extern int strcspn() /= 0x11DF ;
extern char *strncat() /= 0x136E ;
extern int strncmp() /= 0x149B ;
extern int toupper() *= 0xA50 ;
extern char *strncpy() /= 0x15C6 ;
extern char *strpbrk() /= 0x16F5 ;
extern char *strrchr() /= 0x17E0 ;
extern int isalpha() *= 0x9EA ;
extern int isdigit() *= 0x9CE ;
extern int isalnum() *= 0x9DC ;
extern char memmove() /= 0xCD3 ;
extern char *memchr() /= 0xA5F ;
extern int memcmp() /= 0xB06 ;
extern char *memcpy() /= 0xC15 ;
extern char *memset() /= 0xEA4 ;
extern int islower() *= 0xA15 ;
extern int isspace() *= 0xA03 ;
extern int isupper() *= 0xA23 ;
