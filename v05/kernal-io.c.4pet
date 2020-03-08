
#include <baselib.h>

extern _chrout() *= 0xffd2 ;
extern char _chrin() *= 0xffcf ;
extern _getin() *= 0xffe4 ;
extern int __chkin() *= 0xffc6 ;
extern int __chkout() *= 0xffc9 ;

int _chkin(lfn)
int lfn;
{ return(__chkin(lfn>>8)); }

int _chkout(lfn)
int lfn;
{ return(__chkout(lfn>>8)); }

extern _clall() *= 0xffe7 ;
extern int _close() *= 0xffc3 ;
extern _clrchn() *= 0xffcc ;
extern int _open() *= 0xffc0 ;

int open(lfn,ga,sa,nam)
char lfn,ga,sa;
char *nam;
{
  char i,*p;
  int *q;
  for(p=nam;*p;++p) ;
  i=p-nam ;
  p=0xb7;
  *p++ = i; *p++ = lfn; *p++ = sa;
  *p++ = ga; *(q=p) = nam;
  return(_open());
}

extern int _readst() *= 0xffb7 ;

extern char _acptr() *= 0xffa5 ;
extern _ciout() *= 0xffa8 ;
extern _listen() *= 0xffb1 ;
extern _second() *= 0xff93 ;
extern _talk() *= 0xffb4 ;
extern _tksa() *= 0xff96 ;
extern _unlsn() *= 0xffae ;
extern _untlk() *= 0xffab ;

