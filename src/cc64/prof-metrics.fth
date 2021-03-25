
profiler-metric:[ profile-cc64-1
  [memman-etc]
  [file-handling]
  [input]
  [scanner]
  [symtab]
  [parser]
  [pass2]
  [shell]
]profiler-metric

profiler-metric:[ profile-scanner1
  [scanner-alphanum]
  [scanner-keyword]
  [scanner-identifier]
  [scanner-operator]
  [scanner-number]
  [scanner-char/string]
  [scanner-nextword]
  [scanner-comment]
]profiler-metric

profiler-metric:[ profile-scanner2
  [scanner-alphanum]
  [scanner-identifier]
  [scanner-operator]
  [scanner-number]
  [scanner-char/string]
  [scanner-nextword]
  [scanner-comment]
  [scanner-rest]
]profiler-metric

' profiler-report alias profile

\log : profile2file  logfile profiler-report logclose ;
