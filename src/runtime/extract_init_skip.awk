
# Extracts from acme assembler symbol listing the number of initial
# bytes to cut off of a runtime module .j file to get the .i file.

BEGIN {
  lib_start = 0;
  lib_end = 0;
  init_start = 0;
  init_cutoff = 0;
}

/cc64_lib_start/ {
  split($2, a, /\s+/); lib_start = strtonum("0x" a[1]);
}

/cc64_lib_end/ {
  split($2, a, /\s+/); lib_end = strtonum("0x" a[1]);
}

/cc64_init_start/ {
  split($2, a, /\s+/); init_start = strtonum("0x" a[1]);
}

/cc64_init_cutoff/ {
  split($2, a, /\s+/); init_cutoff = strtonum("0x" a[1]);
}

END {
  if (lib_start && lib_end && init_start && init_cutoff) {
    if (lib_end + 2 >= init_start) {
      printf("lib_end (0x%x) too close to init_start (0x%x)\n",
             lib_end, init_start) > "/dev/stderr";
      exit 1;
    }
    if ( init_start - lib_start != init_cutoff) {
      printf("init_start (0x%x) - lib_start (0x%x) != init_cutoff " \
             "(0x%x)\nresult = 0x%x\n", init_start, lib_start,
             init_cutoff, init_start - lib_start) > "/dev/stderr";
      exit 1;
    }

    printf("%d\n", init_cutoff);

  } else {
    printf("Somethings missing when parsing %s\n" \
           " lib_start = '%x'\n lib_end = '%x'\n" \
           " statics_start = '%x'\n init_cutoff = '%x'\n",
           FILENAME, lib_start, lib_end, statics_start,
           init_cutoff) > "/dev/stderr";
    exit 1;
  }
}
