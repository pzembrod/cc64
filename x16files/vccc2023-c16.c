#INCLUDE <RT-C16-10-7F.H>EXTERN _FASTCALL PUTCHAR() *= 0XFFD2 ;INT MAIN() �  STATIC INT I, J, X, Y, DX, DY;  FOR (I=0, Y=3, DY=1; I<19; ++I, Y+=DY) �    DY=(Y==0?1:Y==3?-1:DY);    FOR (J=0, X=0, DX=1; J<19; ++J, X+=DX) �      DX=(X==0?1:X==3?-1:DX);      PUTCHAR(X==Y?'*':' ');    �    PUTCHAR('\N');  ��