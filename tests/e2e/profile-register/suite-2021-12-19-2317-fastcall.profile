2021-12-19T23:17:38+01:00
fastcall declarations and function pointers implemented

profiler report PROFILE-CC64-1
timestamps
587.081.446 749.594.535 
countstamps
5.300.211 6.757.636 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15742 65535       216848    23255415  (etc)
1 19259 19467       113486    12971420  [STRINGS]
2 19479 21698       744114    83580348  [MEMMAN-ETC]
3 21702 22922      1396466   156440776  [FILE-HANDLING]
4 22926 23583       315320    34958368  [INPUT]
5 23587 26274       829111    91606152  [SCANNER]
6 26278 27669       153929    17618048  [SYMTAB]
7 27673 35588      1875549   205369624  [PARSER]
8 35592 37238      1112813   123794263  [PASS2]


profiler report PROFILE-SCANNER-NEXTWORD
timestamps
587.434.781 750.217.505 
countstamps
5.300.211 6.757.636 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15742 65535      6606743   733649693  (etc)
1 25820 25860            0           0  [SCANNER-NEXTWORD-VARS]
2 25864 25926        41158     4587376  [SCANNER-FETCHWORD]
3 25930 25963        85788     9394771  [SCANNER-THISWORD]
4 25967 26005         6531      729529  [SCANNER-NEXTWORD-MARK]
5 26009 26056        17416     1856057  [SCANNER-NEXTWORD-ADVANCED?]
6 65535 65535            0           0
7 65535 65535            0           0
8 65535 65535            0           0


profiler report PROFILE-SCANNER1
timestamps
587.441.678 750.300.384 
countstamps
5.300.211 6.757.636 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15742 65535      6079432   675239935  (etc)
1 23607 23652        54064     5780345  [SCANNER-ALPHANUM]
2 23656 23968         2334      258579  [SCANNER-KEYWORD]
3 23972 24127        66807     7282724  [SCANNER-IDENTIFIER]
4 24131 24711        94045    10187120  [SCANNER-OPERATOR]
5 24715 24955        27340     3529978  [SCANNER-NUMBER]
6 24959 25473       238983    26639388  [SCANNER-CHAR/STRING]
7 25477 25637       150680    16133393  [SCANNER-(NEXTWORD]
8 25641 25787        43951     5248801  [SCANNER-COMMENT]


profiler report PROFILE-SCANNER2
timestamps
587.523.136 750.202.746 
countstamps
5.300.211 6.757.636 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15742 65535      6081752   675381700  (etc)
1 23607 23652        54064     5787814  [SCANNER-ALPHANUM]
2 23972 24127        66807     7284539  [SCANNER-IDENTIFIER]
3 24131 24711        94045    10201681  [SCANNER-OPERATOR]
4 24715 24955        27340     3534296  [SCANNER-NUMBER]
5 24959 25473       238983    26643075  [SCANNER-CHAR/STRING]
6 25477 25637       150680    16118072  [SCANNER-(NEXTWORD]
7 25641 25787        43951     5249926  [SCANNER-COMMENT]
8 26060 26274           14        1522  [SCANNER-REST]


profiler report PROFILE-SCANNER3
timestamps
587.445.310 750.198.507 
countstamps
5.300.211 6.757.636 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15742 65535      5958199   662369334  (etc)
1 23607 23652        54064     5779428  [SCANNER-ALPHANUM]
2 23972 24127        66807     7288155  [SCANNER-IDENTIFIER]
3 24131 24711        94045    10182368  [SCANNER-OPERATOR]
4 24959 25473       238983    26643278  [SCANNER-CHAR/STRING]
5 25477 25637       150680    16115155  [SCANNER-(NEXTWORD]
6 25641 25787        43951     5245051  [SCANNER-COMMENT]
7 25791 26056       150893    16573792  [SCANNER-NEXTWORD]
8 26060 26274           14        1825  [SCANNER-REST]

