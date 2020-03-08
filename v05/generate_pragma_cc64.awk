
# Extracts cc64 baselib addresses from acme assembler symbol listing
# and writes them out in a #pragma cc64 line.

BEGIN {
  cc64_sp = "";
  cc64_zp = "";
  lib_start = "";
  lib_end = "";
  lib_jumplist = "";
  statics_start = "";
  statics_end = "";
  lib_name = "";
}

/cc64_sp/ {
  split($2, a, /\s+/); cc64_sp = a[1];
}

/cc64_zp/ {
  split($2, a, /\s+/); cc64_zp = a[1];
}

/cc64_lib_start/ {
  split($2, a, /\s+/); lib_start = a[1];
  split(FILENAME, b, "."); lib_name = b[1];
}

/cc64_lib_end/ {
  split($2, a, /\s+/); lib_end = a[1];
}

/cc64_lib_jumplist/ {
  split($2, a, /\s+/); lib_jumplist = a[1];
}

/cc64_statics_start/ {
  split($2, a, /\s+/); statics_start = a[1];
}

/cc64_statics_end/ {
  split($2, a, /\s+/); statics_end = a[1];
}

END {
  if (cc64_sp && cc64_zp && lib_start && lib_jumplist && lib_end &&
      statics_start && statics_end && lib_name) {
    printf("#pragma cc64 0x%s 0x%s 0x%s 0x%s 0x%s 0x%s 0x%s %s\n",
           cc64_sp, cc64_zp, lib_start, lib_jumplist, lib_end,
           statics_start, statics_end, lib_name);
  } else {
    printf("Somethings missing when parsing %s\n" \
           " cc64_sp = '%s'\n cc64_zp = '%s'\n lib_start = '%s'\n" \
           " lib_jumplist = '%s'\n lib_end = '%s'\n" \
           " statics_start = '%s'\n statics_end = '%s'\n" \
           " lib_name = '%s'\n",
           FILENAME,
           cc64_sp, cc64_zp, lib_start, lib_jumplist, lib_end,
           statics_start, statics_end, lib_name) > "/dev/stderr";
    exit 1;
  }
}
