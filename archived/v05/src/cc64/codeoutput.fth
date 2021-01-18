\ *** Block No. 77, Hexblock 4d

\ codeoutput: flushcode/static 11sep94pz

make flushcode ( -- )
   code-file fsetout
   code[  pc >codeadr  over -  fputs
   funset  clearcode ;

make flushstatic ( -- )
   static-file fsetout
   static[  static> @  over - fputs
   static[ static> @ - static-offset +!
   funset  clearstatic ;

\ noch schlecht modularisiert:
\    greift auf interne worte des
\    codehandlers zurueck.
