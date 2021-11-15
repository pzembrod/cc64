
fgets_test() {
  int fhw, fhr, i;
  char buffer[10];
  char *fgets_test = "foo\nbar\0baz\nweenie";
  char filename[] = "fgets.tmp";

  remove(filename);
  
  fhw = fopen(filename, ",s,w");
  assertTrue(fhw != NULL, "fhw != NULL");
  for (i=0; i<18; ++i) {
    char c = fgets_test[i];
    assertEq(fputc(c, fhw), c, "fputc(c, fhw)");
  }
  assertEq(fclose(fhw), 0, "fclose(fhw)");

  fhr = fopen(filename, ",s,r");
  assertTrue(fhr != NULL, "fhr != NULL");

  assertEq(fgets(buffer, 10, fhr), buffer, "fgets(buffer, 10, fh)");
  assertEq(strcmp(buffer, "foo\n"), 0, "strcmp(buffer, foo)");
  assertEq(fgets(buffer, 10, fhr), buffer, "fgets(buffer, 10, fhr)");
  assertEq(memcmp(buffer, "bar\0baz\n", 8), 0,
      "memcmp(buffer, bar0baz, 8)");
  assertEq(fgets(buffer, 10, fhr), buffer, "fgets(buffer, 10, fhr)");
  assertEq(strcmp(buffer, "weenie"), 0, "strcmp(buffer, weenie)");

  assertEq(fclose(fhr), 0, "fclose(fhr)");

  evaluateAsserts();
}

/*
int xmain( void )
{
    FILE * fh;
    char buffer[10];
    const char * fgets_test = "foo\nbar\0baz\nweenie";
    TESTCASE( ( fh = fopen( testfile, "wb+" ) ) != NULL );
    TESTCASE( fwrite( fgets_test, 1, 18, fh ) == 18 );
    rewind( fh );
    * 
    TESTCASE( fgets( buffer, 10, fh ) == buffer );
    TESTCASE( strcmp( buffer, "foo\n" ) == 0 );
    TESTCASE( fgets( buffer, 10, fh ) == buffer );
    TESTCASE( memcmp( buffer, "bar\0baz\n", 8 ) == 0 );
    TESTCASE( fgets( buffer, 10, fh ) == buffer );
    TESTCASE( strcmp( buffer, "weenie" ) == 0 );

    TESTCASE( feof( fh ) );
    TESTCASE( fseek( fh, -1, SEEK_END ) == 0 );
    /* newlib returns NULL on any n < 2, so we _NOREG these tests. /
    TESTCASE_NOREG( fgets( buffer, 1, fh ) == buffer );
    TESTCASE_NOREG( strcmp( buffer, "" ) == 0 );
    TESTCASE( fgets( buffer, 0, fh ) == NULL );
    TESTCASE( ! feof( fh ) );
    TESTCASE_NOREG( fgets( buffer, 1, fh ) == buffer );
    TESTCASE_NOREG( strcmp( buffer, "" ) == 0 );
    TESTCASE( ! feof( fh ) );
    TESTCASE( fgets( buffer, 2, fh ) == buffer );
    TESTCASE( strcmp( buffer, "e" ) == 0 );
    TESTCASE( fseek( fh, 0, SEEK_END ) == 0 );
    TESTCASE( fgets( buffer, 2, fh ) == NULL );
    TESTCASE( feof( fh ) );
    TESTCASE( fclose( fh ) == 0 );
    TESTCASE( remove( testfile ) == 0 );
    return TEST_RESULTS;
}
*/
