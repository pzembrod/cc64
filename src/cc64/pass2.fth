\ *** Block No. 108, Hexblock 6c

\ pass2 :  loadscreen          21sep94pz

\ *** Block No. 109, Hexblock 6d

\   pass2 :                    11sep94pz

|| variable #toread
|| variable #inbuf
|| variable p2in>
|| ' code[ ALIAS p2in[
|| ' ]code ALIAS ]p2in


|| : p2readcode  ( -- )
     #toread @ 0=     *compiler* ?fatal
     code-file feof? *obj-short* ?fatal
     code-file fsetin   p2in[ p2in> !
     p2in[  ]p2in over - #toread @ umin
     fgets  dup #inbuf !
         negate #toread +!   funset ;

|| : p2code@ ( -- 8b )
     (CX enable-code[]-bank C)
     #inbuf @ 0= IF p2readcode THEN
     -1 #inbuf +!
     p2in> @ c@  1 p2in> +! ;


\ *** Block No. 110, Hexblock 6e

\   pass2 :                    13sep94pz

|| variable p2out>
|| ' static[ ALIAS p2out[
|| ' ]static ALIAS ]p2out


|| : p2flush  ( -- )
     exe-file fsetout
     p2out[ p2out> @ over - fputs
     funset
     p2out[ p2out> ! ;

|| : p2code!  ( 8b -- )
     p2out> @  under  c!
     1+ dup p2out> !
     ]p2out = IF p2flush THEN ;

|| : init-p2i/o  ( -- )
     p2out[  p2out> ! ;

    init: init-p2i/o


\ *** Block No. 111, Hexblock 6f

\   pass2 :                    13sep94pz

|| : p2copy  ( last.adr+1 first.adr -- )
     ?DO p2code@ p2code! LOOP ;

|| : p2wcode!  ( 16b -- )
     >lo/hi swap p2code! p2code! ;

|| : p2wcode@drop  ( -- )
     p2code@ p2code@ 2drop ;

|| : p2openfile
    ( len mode type name handle -- )
     ." linking " over count type cr
     fopen  2+ #toread !  #inbuf off
     p2readcode ;

|| : p2closefile  ( handle -- )
     dup fclose
     feof? 0= *obj-long* ?fatal
     #toread @ #inbuf @ or
     *compiler* ?fatal ;


\ *** Block No. 112, Hexblock 70

\   pass2 :                    21sep94pz

|| : link-runtimemodule  ( -- )
     ascii w ascii p exe-name
     exe-file fopen
     code.first @ lib.first @ -
     ascii r ascii p lib.codename
     code-file p2openfile
     >runtime @  lib.first @
     2- p2copy  \ copy load adress, too
     8 0 DO p2code@ drop LOOP
     main()-adr @    p2wcode!
     code.last @     p2wcode!
     statics.first @ p2wcode!
     statics.last @  p2wcode!
     code.first @ >runtime @ 8 + p2copy
     p2flush exe-file fclose
     code-file p2closefile ;


\ *** Block No. 113, Hexblock 71

\   pass2 :                    21sep94pz

|| variable p2pc

|| : link-code  ( -- )
     ascii a ascii p exe-name
     exe-file fopen
     code.last @ code.first @ -
     ascii r ascii p code-name
     code-file p2openfile
     p2wcode@drop \ drop load address
     code.first @ p2pc !
     BEGIN protos2patch hook-out ?dup
     WHILE dup 4 + @  ( list patchadr )
     dup  p2pc @  p2copy ( dito )
     2+ p2pc !  p2wcode@drop  ( list )
     2+ @ >lo/hi swap p2code! p2code!
     REPEAT
     code.last @  p2pc @ p2copy
     p2flush exe-file fclose
     code-file p2closefile ;


\ *** Block No. 114, Hexblock 72

\   pass2 :                    14jan96pz

|| : (link-statics  ( n filename -- )
     over 0=
        IF ." no need to link "
        count type cr  drop exit THEN
     ascii a ascii p exe-name
                      exe-file fopen
     >r dup ascii r ascii p r>
               code-file  p2openfile
     p2wcode@drop  \ drop load address
     0 p2copy
     p2flush exe-file fclose
     code-file p2closefile ;

|| : link-statics  ( -- )
     statics.last @ statics.libfirst @
     - lib.initname (link-statics
     statics.libfirst @ statics.first @
     - static-name (link-statics ;


\ *** Block No. 115, Hexblock 73

\   pass2 :                    21sep94pz

|| : (link-lib ( n in-name w/a -- )
     dup >r
     ascii p exe-name exe-file fopen
     >r dup ascii r ascii p r>
                 code-file p2openfile
     r> ascii w =
        IF 2+ \ copy load adress
        ELSE p2wcode@drop THEN
     0 p2copy
     p2flush exe-file fclose
     code-file p2closefile ;

|| : link-libstatics  ( -- )
   statics.last @ statics.libfirst  @ -
   lib.initname  ascii w (link-lib
   statics.libfirst @ statics.first @ -
   static-name   ascii a (link-lib ;


\ *** Block No. 116, Hexblock 74

\   pass2 :                    07may95pz

|| : write-libheader ( -- )
     cr!
     " #pragma cc64" str!
     >base         @ hex!
     >zp           @ hex!
     lib.first     @ hex!
     >runtime      @ hex!
     code.last     @ hex!
     statics.first @ hex!
     statics.last  @ hex!  bl fputc
     exe-name count 2 - fputs
     cr! cr! ;

|| : checksize ( -- )
     statics.last @ lib.first @ u> IF
       \ assuming soft stack starts after static init values:
       statics.first @ statics.last @ over - - code.last @
       2dup - . ." free dyn mem" cr
       $100 + u< *codetoolong* ?fatal THEN ;

\ *** Block No. 117, Hexblock 75

\   pass2 :                    11sep94pz


\ *** Block No. 118, Hexblock 76

\   pass2 :                    11sep94pz

|| : write-declarations  ( -- )
     ." creating " exe-name count
     type cr    ascii w ascii s
     exe-name exe-file fopen
     exe-file fsetout
     write-libheader
     ]hash hash[
     DO I @ ?dup
        IF dup count + 2@
        (write-decl THEN
     2 +LOOP
     funset  exe-file fclose ;

|| : link-lib  ( -- )
     code.suffix  exe-name strcat
     link-runtimemodule  link-code
     exe-name cut-suffix
     init.suffix exe-name strcat
     link-libstatics
     exe-name cut-suffix
     decl.suffix exe-name strcat
     write-declarations ;


\ *** Block No. 119, Hexblock 77

\   pass2 :                    11sep94pz

|| : link-exe  ( -- )
     link-runtimemodule  link-code
     link-statics ;

~ : pass2  ( -- )
     checksize
     main()-adr @
        IF link-exe
        ELSE link-lib THEN ;
