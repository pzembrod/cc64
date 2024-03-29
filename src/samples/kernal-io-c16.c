
#include <rt-c16-10-7f.h>

extern _fastcall _chrout() *= 0xffd2 ;
extern _fastcall char _chrin() *= 0xffcf ;
extern _fastcall _getin() *= 0xffe4 ;
extern _fastcall int __chkin() *= 0xffc6 ;
extern _fastcall int __chkout() *= 0xffc9 ;

int _chkin(lfn)
int lfn;
{ return(__chkin(lfn<<8)); }

int _chkout(lfn)
int lfn;
{ return(__chkout(lfn<<8)); }

extern _fastcall _clall() *= 0xffe7 ;
extern _fastcall _close() *= 0xffc3 ;
extern _fastcall _clrchn() *= 0xffcc ;
extern _fastcall __open() *= 0xffc0 ;

extern char _kernal_fnam_len *= 0xab;
extern char _kernal_lfn *= 0xac;
extern char _kernal_sa *= 0xad;
extern char _kernal_fa *= 0xae;
extern int _kernal_fnam *= 0xaf;

int _open(lfn, fa, sa, fnam)
char lfn, fa, sa;
char *fnam;
{
  char *p;
  for(p=fnam; *p; ++p);
  _kernal_fnam_len = p-fnam;
  _kernal_lfn = lfn;
  _kernal_fa = fa;
  _kernal_sa = sa;
  _kernal_fnam = fnam;
  __open();
}

extern _fastcall int _readst() *= 0xffb7 ;

extern _fastcall char _acptr() *= 0xffa5 ;
extern _fastcall _ciout() *= 0xffa8 ;
extern _fastcall _listen() *= 0xffb1 ;
extern _fastcall _second() *= 0xff93 ;
extern _fastcall _talk() *= 0xffb4 ;
extern _fastcall _tksa() *= 0xff96 ;
extern _fastcall _unlsn() *= 0xffae ;
extern _fastcall _untlk() *= 0xffab ;
