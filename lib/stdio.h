
extern int fopen(char* filename, char* mode);
extern _fastcall int fclose(int fh);
extern _fastcall int fgetc(int fh);
extern int fputc(int c, int fh);
extern char* fgets(char* str, int count, int fh);
extern int fputs(char* str, int fh);
extern _fastcall int putchar(int c);
extern _fastcall int puts(char* str);

int printf(); /* (char* fmtstr, ...); */
int fprintf(); /* (int fh, char* fmtstr, ...); */
int sprintf(); /* (char* buffer, char* fmtstr, ...); */
