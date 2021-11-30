
static char fprintf_file[] = "fprintf.out1";
int fh;

fp(int len) {
  fprintf(fh, "%d\n", len);
}

fprintf_test1() {
INCLUDE
}

fprintf_test() {
  remove(fprintf_file);

  assertTrue((fh = fopen(fprintf_file, ",s,w")) != 0,
      "fopen(fprintf_file, \",s,w\")");
  fprintf_test1();
  /* golden file generation produces the "No assert failed." line. */
  fprintf(fh, "No assert failed.\n");
  fclose(fh);

  evaluateAsserts();
}
