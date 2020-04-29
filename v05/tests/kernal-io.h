
extern _chrout() *= 0xffd2 ;
extern char _chrin() *= 0xffcf ;
extern _getin() *= 0xffe4 ;

int puts(s)
char *s;
{
  while(*s != 0)
     _chrout(*s++);
}

extern int __chkin() *= 0xffc6 ;
extern int __chkout() *= 0xffc9 ;

int _chkin(lfn)
int lfn;
{ return(__chkin(lfn<<8)); }

int _chkout(lfn)
int lfn;
{ return(__chkout(lfn<<8)); }

extern _clall() *= 0xffe7 ;
extern int _close() *= 0xffc3 ;
extern _clrchn() *= 0xffcc ;
extern char _open() *= 0xffc0 ;

extern char _kernal_fnam_len /= 0xb7;
extern char _kernal_lfn /= 0xb8;
extern char _kernal_sa /= 0xb9;
extern char _kernal_fa /= 0xba;
extern int _kernal_fnam /= 0xbb;

int open(lfn, fa, sa, fnam)
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
  return(_open());
}

int open2(lfn,ga,sa,nam)
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

