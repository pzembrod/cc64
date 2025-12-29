
\ minilinker, formerly mis-named pass2

|| variable #toread
|| variable #inbuf
|| variable link-in>
|| ' code[ ALIAS link-in[
|| ' ]code ALIAS ]link-in


|| : read-in[]  ( -- )
     #toread @ 0=     *compiler* ?fatal
     code-file feof? *obj-short* ?fatal
     code-file fsetin   link-in[ link-in> !
     link-in[  ]link-in over - #toread @ umin
     fgets  dup #inbuf !
         negate #toread +!   funset ;

|| : link@ ( -- 8b )
     (CX enable-code[]-bank C)
     #inbuf @ 0= IF read-in[] THEN
     -1 #inbuf +!
     link-in> @ c@  1 link-in> +! ;


|| variable link-out>
|| ' static[ ALIAS link-out[
|| ' ]static ALIAS ]link-out


|| : link-flush  ( -- )
     exe-file fsetout
     link-out[ link-out> @ over - fputs
     funset
     link-out[ link-out> ! ;

|| : link!  ( 8b -- )
     link-out> @  under  c!
     1+ dup link-out> !
     ]link-out = IF link-flush THEN ;

|| : init-link  ( -- )
     link-out[  link-out> ! ;

    init: init-link


|| : link-copy  ( last.adr+1 first.adr -- )
     ?DO link@ link! LOOP ;

|| : linkw!  ( 16b -- )
     >lo/hi swap link! link! ;

|| : linkw@drop  ( -- )
     link@ link@ 2drop ;

|| : link-open
    ( len mode type name handle -- )
     ." linking " over count type cr
     fopen  2+ #toread !  #inbuf off
     read-in[] ;

|| : link-close  ( handle -- )
     dup fclose
     feof? 0= *obj-long* ?fatal
     #toread @ #inbuf @ or
     *compiler* ?fatal ;


|| : link-runtimemodule  ( -- )
     ascii w ascii p exe-name
     exe-file fopen
     code.first @ lib.first @ -
     ascii r ascii p lib.codename
     code-file link-open
     >runtime @  lib.first @
     2- link-copy  \ copy load adress, too
     8 0 DO link@ drop LOOP
     main()-adr @    linkw!
     code.last @     linkw!
     statics.first @ linkw!
     statics.last @  linkw!
     code.first @ >runtime @ 8 + link-copy
     link-flush exe-file fclose
     code-file link-close ;


|| variable patch>

|| : link-code  ( -- )
     ascii a ascii p exe-name
     exe-file fopen
     code.last @ code.first @ -
     ascii r ascii p code-name
     code-file link-open
     linkw@drop \ drop load address
     code.first @ patch> !
     BEGIN protos2patch hook-out ?dup
     WHILE dup 4 + @  ( list patchadr )
     dup  patch> @  link-copy ( dito )
     2+ patch> !  linkw@drop  ( list )
     2+ @ >lo/hi swap link! link!
     REPEAT
     code.last @  patch> @ link-copy
     link-flush exe-file fclose
     code-file link-close ;


|| : (link-statics  ( n filename -- )
     over 0=
        IF ." no need to link "
        count type cr  drop exit THEN
     ascii a ascii p exe-name
                      exe-file fopen
     >r dup ascii r ascii p r>
               code-file  link-open
     linkw@drop  \ drop load address
     0 link-copy
     link-flush exe-file fclose
     code-file link-close ;

|| : link-statics  ( -- )
     statics.last @ statics.libfirst @
     - lib.initname (link-statics
     statics.libfirst @ statics.first @
     - static-name (link-statics ;


|| : (link-lib ( n in-name w/a -- )
     dup >r
     ascii p exe-name exe-file fopen
     >r dup ascii r ascii p r>
                 code-file link-open
     r> ascii w =
        IF 2+ \ copy load adress
        ELSE linkw@drop THEN
     0 link-copy
     link-flush exe-file fclose
     code-file link-close ;

|| : link-libstatics  ( -- )
   statics.last @ statics.libfirst  @ -
   lib.initname  ascii w (link-lib
   statics.libfirst @ statics.first @ -
   static-name   ascii a (link-lib ;


|| : write-libheader ( -- )
     cr!
     " #pragma cc64" str!
     >frame        @ hex!
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


|| : link-exe  ( -- )
     link-runtimemodule  link-code
     link-statics ;

~ : link-all  ( -- )
     checksize
     main()-adr @
        IF link-exe
        ELSE link-lib THEN ;
