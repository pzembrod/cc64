
# Extracts runtime module addresses from acme assembler symbol listing
# and writes them out in a #pragma cc64 line.

BEGIN {
  cc64_frameptr = "";
  cc64_zp = "";
  lib_start = "";
  lib_end = "";
  lib_jumplist = "";
  statics_start = "";
  statics_end = "";
  lib_name = "";

  type_formats["1"] = "_fastcall int %s()";
  type_formats["2"] = "_fastcall char %s()";
  type_formats["3"] = "_fastcall int *%s()";
  type_formats["4"] = "_fastcall char *%s()";
  type_formats["5"] = "int %s()";
  type_formats["6"] = "char %s()";
  type_formats["7"] = "int *%s()";
  type_formats["8"] = "char *%s()";
  type_formats["9"] = "int %s";
  type_formats["a"] = "char %s";
  type_formats["b"] = "int *%s";
  type_formats["c"] = "char *%s";
}

/cc64_frameptr/ {
  split($2, a, /\s+/); cc64_frameptr = a[1];
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

/cc64_symbol_/ {
  name = $1;
  gsub(/\s+/, "", name);
  sub(/cc64_symbol_/, "", name);
  sub(/=/, "", name);
  split($2, val, /\s+/);
  symbols[name] = val[1];
}

/cc64_type_/ {
  name = $1;
  gsub(/\s+/, "", name);
  sub(/cc64_type_/, "", name);
  sub(/=/, "", name);
  split($2, val, /\s+/);
  if (val[1] in type_formats) {
    symbol_formats[name] = type_formats[val[1]];
  }
}

END {
  if (cc64_frameptr && cc64_zp && lib_start && lib_jumplist &&
      lib_end && statics_start && statics_end && lib_name) {
    printf("#pragma cc64 0x%s 0x%s 0x%s 0x%s 0x%s 0x%s 0x%s %s\n",
           cc64_frameptr, cc64_zp, lib_start, lib_jumplist, lib_end,
           statics_start, statics_end, lib_name);
    for (name in symbols) {
      value = symbols[name]
      if (name in symbol_formats) {
        printf(symbol_formats[name], name);
      } else {
        printf("%s", name);
      }
      printf(" *= 0x%s;\n", value);
    }
  } else {
    printf("Somethings missing when parsing %s\n" \
           " cc64_frameptr = '%s'\n cc64_zp = '%s'\n" \
           " lib_start = '%s'\n lib_jumplist = '%s'\n" \
           " lib_end = '%s'\n statics_start = '%s'\n" \
           " statics_end = '%s'\n lib_name = '%s'\n",
           FILENAME,
           cc64_frameptr, cc64_zp, lib_start, lib_jumplist, lib_end,
           statics_start, statics_end, lib_name) > "/dev/stderr";
    exit 1;
  }
}
