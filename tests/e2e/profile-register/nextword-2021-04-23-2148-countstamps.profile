2021-04-23T21:48:00+02:00
added deterministic countstamps. fixed timestamps low word random bug

profiler report PROFILE-SCANNER-NEXTWORD
timestamps
580.019.275 740.844.536 
countstamps
5.290.027 6.743.516 

buckets
b# addr[  ]addr  nextcounts  clockticks  name
0 15885 65535      6592514   724416147  (etc)
1 25828 25868            0           0  [SCANNER-NEXTWORD-VARS]
2 25872 25934        41378     4577552  [SCANNER-FETCHWORD]
3 25938 25971        85677     9296837  [SCANNER-THISWORD]
4 25975 26013         6531      722558  [SCANNER-NEXTWORD-MARK]
5 26017 26064        17416     1831278  [SCANNER-NEXTWORD-ADVANCED?]
6 65535 65535            0           0
7 65535 65535            0           0
8 65535 65535            0           0

