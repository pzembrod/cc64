2021-04-03T23:37:17+02:00
nextword/backword replaced by thisword/accept

profiler report PROFILE-CC64-1
timestamps
635.227.308 794.348.749 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15885 65535       497891    55192602  (etc)
1 19316 21453       939654   103578004  [MEMMAN-ETC]
2 21457 22676      1384422   153259960  [FILE-HANDLING]
3 22680 23337       313716    34378460  [INPUT]
4 23341 26062      1019251   113532446  [SCANNER]
5 26066 27442       153639    17411979  [SYMTAB]
6 27446 35465      1805554   195706591  [PARSER]
7 35469 37027      1101091   121325306  [PASS2]
8 37170 37920            0           0  [SHELL]


profiler report PROFILE-SCANNER-NEXTWORD
timestamps
635.423.916 794.807.501 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15885 65535      7065330   778562120  (etc)
1 25608 25648            0           0  [SCANNER-NEXTWORD-VARS]
2 25652 25714        41092     4523890  [SCANNER-FETCHWORD]
3 25718 25751        85047     9205894  [SCANNER-THISWORD]
4 25755 25793         6477      711890  [SCANNER-NEXTWORD-MARK]
5 25797 25844        17272     1824100  [SCANNER-NEXTWORD-ADVANCED?]
6 65535 65535            0           0
7 65535 65535            0           0
8 65535 65535            0           0


profiler report PROFILE-SCANNER1
timestamps
635.423.916 794.741.965 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15885 65535      6345869   697567146  (etc)
1 23361 23467       247524    29349827  [SCANNER-ALPHANUM]
2 23471 23752         2334      236122  [SCANNER-KEYWORD]
3 23756 23911        66366     7038192  [SCANNER-IDENTIFIER]
4 23915 24499        93760     9999244  [SCANNER-OPERATOR]
5 24503 24743        27320     3484075  [SCANNER-NUMBER]
6 24747 25261       237738    26069501  [SCANNER-CHAR/STRING]
7 25265 25425       150422    15885237  [SCANNER-(NEXTWORD]
8 25429 25575        43885     5177003  [SCANNER-COMMENT]


profiler report PROFILE-SCANNER2
timestamps
635.620.524 795.004.109 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15885 65535      6348189   698027776  (etc)
1 23361 23467       247524    29372800  [SCANNER-ALPHANUM]
2 23756 23911        66366     7044998  [SCANNER-IDENTIFIER]
3 23915 24499        93760    10006165  [SCANNER-OPERATOR]
4 24503 24743        27320     3484340  [SCANNER-NUMBER]
5 24747 25261       237738    26065845  [SCANNER-CHAR/STRING]
6 25265 25425       150422    15870590  [SCANNER-(NEXTWORD]
7 25429 25575        43885     5195541  [SCANNER-COMMENT]
8 25848 26062           14        1897  [SCANNER-REST]


profiler report PROFILE-SCANNER3
timestamps
635.489.452 794.873.037 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15885 65535      6225621   685133179  (etc)
1 23361 23467       247524    29335672  [SCANNER-ALPHANUM]
2 23756 23911        66366     7032118  [SCANNER-IDENTIFIER]
3 23915 24499        93760     9997433  [SCANNER-OPERATOR]
4 24747 25261       237738    26098202  [SCANNER-CHAR/STRING]
5 25265 25425       150422    15861717  [SCANNER-(NEXTWORD]
6 25429 25575        43885     5193847  [SCANNER-COMMENT]
7 25579 25844       149888    16295019  [SCANNER-NEXTWORD]
8 25848 26062           14        1679  [SCANNER-REST]
