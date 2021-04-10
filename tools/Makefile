# Where to put the executable for the command 'gcc'.
bindir = $(HOME)/bin

imagetools = bin2p00 bin2t64 txt2s00
filetools =  ascii2petscii petscii2ascii striploadaddress ufscr2file
tools = $(imagetools) $(filetools) patch-c-charset

all: $(tools)

clean:
	rm -f  $(tools)
	rm -f *.o test_*.fth


ascii2petscii: ascii2petscii.o petscii.o openfiles.o

ascii2petscii.o: ascii2petscii.c openfiles.h petscii.h


bin2p00: bin2p00.o petscii.o openfiles.o

bin2p00.o: bin2p00.c openfiles.h petscii.h


bin2t64: bin2t64.o petscii.o openfiles.o

bin2t64.o: bin2t64.c openfiles.h petscii.h


patch-c-charset: patch-c-charset.o openfiles.o

patch-c-charset.o: patch-c-charset.c openfiles.h


petscii2ascii: petscii2ascii.o petscii.o openfiles.o

petscii2ascii.o: petscii2ascii.c openfiles.h petscii.h


striploadaddress: striploadaddress.o openfiles.o

striploadaddress.o: striploadaddress.c openfiles.h


txt2s00: txt2s00.o petscii.o openfiles.o

txt2s00.o: txt2s00.c openfiles.h petscii.h


ufscr2file: ufscr2file.o petscii.o openfiles.o

ufscr2file.o: ufscr2file.c openfiles.h petscii.h


openfiles.o: openfiles.c openfiles.h

petscii.o: petscii.c petscii.h


install: $(tools)
	cp $+ $(bindir)/

test: test_ufscr2file_file test_ufscr2file_stdout test_petscii \
  test_ufscr2file_buffered test_ufscr2file_shadow

test_ufscr2file_file: ufscr2file
	./ufscr2file testdata/testsrc.d64 test_file.fth
	diff test_file.fth testdata/testsrc.fth

test_ufscr2file_stdout: ufscr2file
	./ufscr2file testdata/testsrc.d64 >test_stdout.fth
	diff test_stdout.fth testdata/testsrc.fth

test_ufscr2file_buffered: ufscr2file
	./ufscr2file -b testdata/testsrc.d64 test_file.fth
	diff test_file.fth testdata/testsrc.fth

test_ufscr2file_shadow: ufscr2file
	./ufscr2file -s testdata/testshadow.d64 test_file.fth
	diff test_file.fth testdata/testshadow.fth

test_petscii: petscii_test
	./petscii_test

petscii_test: petscii_test.o petscii.o

petscii_test.o: petscii_test.c petscii.h cheat.h
