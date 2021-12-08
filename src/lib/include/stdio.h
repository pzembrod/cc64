
extern int fopen(char* filename, char* mode);
/* As yet there is no way to declare fastcall functions without
 * defining them.
__fastcall extern int fclose(int fh); /* */
/*
__fastcall extern int fgetc(int fh); /* */
extern int fputc(int c, int fh);
extern char* fgets(char* str, int count, int fh);
extern int fputs(char* str, int fh);
/*
__fastcall extern int putchar(int c); /* */
/*
__fastcall extern int puts(char* str); /* */

int printf(); /* (char* fmtstr, ...); */
int fprintf(); /* (int fh, char* fmtstr, ...); */
int sprintf(); /* (char* buffer, char* fmtstr, ...); */
