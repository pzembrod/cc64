
  31  constant /id
  4   constant /symbol \ datenfeldgroesse
  8   constant #globals
  100 constant symtabsize
  create hash[ #globals 2+ allot  here constant ]hash
  create symtab[ symtabsize allot  here constant ]symtab
