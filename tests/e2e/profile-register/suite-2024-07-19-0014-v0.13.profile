2024-07-19T00:14:30+02:00


profiler report PROFILE-CC64-1
timestamps
587.446.630 751.075.942 
countstamps
5.300.451 6.759.271 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 3D9B FFFF       223974    24592903  (etc)
1 4A08 4ADA       113486    12978357  [STRINGS]
2 4AE6 542B       744244    83546841  [MEMMAN-ETC]
3 542F 5973      1397684   157468603  [FILE-HANDLING]
4 5977 5C0B       315320    34994881  [INPUT]
5 5C0F 66AF       829111    91293991  [SCANNER]
6 66CC 6978       146878    16830034  [SYMTAB]
7 6C58 8C0B      1875549   205476233  [PARSER]
8 8C0F 921E      1113025   123893978  [PASS2]


profiler report PROFILE-SCANNER-NEXTWORD
timestamps
587.876.956 751.720.029 
countstamps
5.300.451 6.759.271 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 3D9B FFFF      6608378   735172732  (etc)
1 64DD 6507            0           0  [SCANNER-NEXTWORD-VARS]
2 650B 654B        41158     4581727  [SCANNER-FETCHWORD]
3 654F 6572        85788     9392041  [SCANNER-THISWORD]
4 6576 659E         6531      725104  [SCANNER-NEXTWORD-MARK]
5 65A2 65D3        17416     1848304  [SCANNER-NEXTWORD-ADVANCED?]
6 FFFF FFFF            0           0
7 FFFF FFFF            0           0
8 FFFF FFFF            0           0


profiler report PROFILE-SCANNER1
timestamps
587.829.895 751.686.239 
countstamps
5.300.451 6.759.271 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 3D9B FFFF      6081067   676939311  (etc)
1 5C25 5C54        54064     5764364  [SCANNER-ALPHANUM]
2 5C58 5D92         2334      255676  [SCANNER-KEYWORD]
3 5D96 5E33        66807     7280949  [SCANNER-IDENTIFIER]
4 5E37 607E        94045    10151965  [SCANNER-OPERATOR]
5 6082 6174        27340     3510784  [SCANNER-NUMBER]
6 6178 637C       238983    26458150  [SCANNER-CHAR/STRING]
7 6380 6422       150680    16081451  [SCANNER-(NEXTWORD]
8 6426 64BA        43951     5243468  [SCANNER-COMMENT]


profiler report PROFILE-SCANNER2
timestamps
587.787.844 751.604.260 
countstamps
5.300.451 6.759.271 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 3D9B FFFF      6083387   677110497  (etc)
1 5C25 5C54        54064     5757756  [SCANNER-ALPHANUM]
2 5D96 5E33        66807     7277969  [SCANNER-IDENTIFIER]
3 5E37 607E        94045    10136248  [SCANNER-OPERATOR]
4 6082 6174        27340     3513266  [SCANNER-NUMBER]
5 6178 637C       238983    26470250  [SCANNER-CHAR/STRING]
6 6380 6422       150680    16094733  [SCANNER-(NEXTWORD]
7 6426 64BA        43951     5241898  [SCANNER-COMMENT]
8 65D7 66AF           14        1522  [SCANNER-REST]


profiler report PROFILE-SCANNER3
timestamps
587.856.246 751.687.232 
countstamps
5.300.451 6.759.271 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 3D9B FFFF      5959834   664150672  (etc)
1 5C25 5C54        54064     5756326  [SCANNER-ALPHANUM]
2 5D96 5E33        66807     7281649  [SCANNER-IDENTIFIER]
3 5E37 607E        94045    10143614  [SCANNER-OPERATOR]
4 6178 637C       238983    26473636  [SCANNER-CHAR/STRING]
5 6380 6422       150680    16087776  [SCANNER-(NEXTWORD]
6 6426 64BA        43951     5243626  [SCANNER-COMMENT]
7 64BE 65D3       150893    16548119  [SCANNER-NEXTWORD]
8 65D7 66AF           14        1693  [SCANNER-REST]

