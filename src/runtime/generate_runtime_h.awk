
# Extracts runtime module addresses from acme assembler symbol listing
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
  # fastcall_functions = []
  type_code[1] = "int ";
  type_code[2] = "char ";
  type_code[3] = "int *";
  type_code[4] = "char *";
}

/cc64_sp/ {
  split($2, a, /\s+/); cc64_sp = a[1];
}

/cc64_zp/ {
  split($2, a, /\s+/); cc64_zp = a[1];
}

/cc64_lib_start/ {
  split($2, a, /\s+/); lib_start = a[1];
  split(FILENAME, p, "/"); basename = p[length(p)];
  split(basename, b, "."); lib_name = b[1];
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

/cc64_fastcall_/ {
  f = $1; 
  gsub(/\s+/, "", f);
  sub(/cc64_fastcall_/, "", f);
  sub(/=/, "", f);
  split($2, a, /\s+/);
  fastcall_functions[f] = a[1];
}

/cc64_type_/ {
  t = $1;
  gsub(/\s+/, "", t);
  sub(/cc64_type_/, "", t);
  sub(/=/, "", t);
  split($2, a, /\s+/);
  if (a[1] in type_code) {
    fastcall_types[t] = type_code[a[1]];
  }
}

END {
  if (cc64_sp && cc64_zp && lib_start && lib_jumplist && lib_end &&
      statics_start && statics_end && lib_name) {
    printf("#pragma cc64 0x%s 0x%s 0x%s 0x%s 0x%s 0x%s 0x%s %s\n",
           cc64_sp, cc64_zp, lib_start, lib_jumplist, lib_end,
           statics_start, statics_end, lib_name);
    for (name in fastcall_functions) {
      if (name in fastcall_types) {
        printf("%s", fastcall_types[name]);
      }
      printf("%s() *= 0x%s;\n", name, fastcall_functions[name]);
    }
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
