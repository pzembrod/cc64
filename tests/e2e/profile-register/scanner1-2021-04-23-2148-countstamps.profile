2021-04-23T21:48:00+02:00
added deterministic countstamps. fixed timestamps low word random bug

profiler report PROFILE-SCANNER1
timestamps
580.021.390 740.847.461 
countstamps
5.290.027 6.743.516 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15885 65535      6062142   666297372  (etc)
1 23605 23650        54266     5723234  [SCANNER-ALPHANUM]
2 23654 23972         2352      254626  [SCANNER-KEYWORD]
3 23976 24131        66969     7263907  [SCANNER-IDENTIFIER]
4 24135 24720        94351    10076657  [SCANNER-OPERATOR]
5 24724 24964        27320     3486299  [SCANNER-NUMBER]
6 24968 25481       240309    26428778  [SCANNER-CHAR/STRING]
7 25485 25645       151636    16086836  [SCANNER-(NEXTWORD]
8 25649 25795        44171     5229673  [SCANNER-COMMENT]

