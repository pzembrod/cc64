
profiler-metric:[ profile-cc64-1
  [strings]
  [memman-etc]
  [file-handling]
  [input]
  [scanner]
  [symtab]
  [parser]
  [pass2]
]profiler-metric

profiler-metric:[ profile-scanner1
  [scanner-alphanum]
  [scanner-keyword]
  [scanner-identifier]
  [scanner-operator]
  [scanner-number]
  [scanner-char/string]
  [scanner-(nextword]
  [scanner-comment]
]profiler-metric

profiler-metric:[ profile-scanner2
  [scanner-alphanum]
  [scanner-identifier]
  [scanner-operator]
  [scanner-number]
  [scanner-char/string]
  [scanner-(nextword]
  [scanner-comment]
  [scanner-rest]
]profiler-metric

profiler-metric:[ profile-scanner3
  [scanner-alphanum]
  [scanner-identifier]
  [scanner-operator]
  [scanner-char/string]
  [scanner-(nextword]
  [scanner-comment]
  [scanner-nextword]
  [scanner-rest]
]profiler-metric

profiler-metric:[ profile-scanner-nextword
  [scanner-nextword-vars]
  [scanner-fetchword]
  [scanner-thisword]
  [scanner-nextword-mark]
  [scanner-nextword-advanced?]
]profiler-metric

' profiler-report alias profile
' bucket-size-report alias sizes

\log : profile2file  logfile profiler-report logclose ;
