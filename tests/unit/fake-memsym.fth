\ fake symbol table memory setup for unit tests

  31  constant /id
  4   constant /symbol \ datenfeldgroesse
  32  constant #buckets
  100 constant symtabsize
  create hash[ #buckets 2* allot  here constant ]hash
  create symtab[ symtabsize allot  here constant ]symtab
