
BEGIN { first = 0; last = 0; jumplist = 0; libname = "baselib"; }

/aa_lib_first/ { split($2, a, /\s+/); first = a[1]; }

/aa_lib_last/ { split($2, a, /\s+/); last = a[1]; }

/aa_lib_jumplist/ { split($2, a, /\s+/); jumplist = a[1]; }

END {
  printf("#pragma cc64 0x%s 0x%s 0x%s 0x%s 0x%s 0x%s 0x%s %s\n",
         "fd", "fb", first, jumplist, last, "a000", "a000", libname);
}
