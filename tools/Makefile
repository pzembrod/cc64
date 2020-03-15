# Where to put the executable for the command 'gcc'.
bindir = $(HOME)/bin

all: ascii2petscii petscii2ascii striploadaddress ufscr2file

clean:
	rm -f ascii2petscii petscii2ascii striploadaddress
	rm -f ufscr2file petscii_test
	rm -f *.o test_*.fth


ascii2petscii: ascii2petscii.o petscii.o openfiles.o

ascii2petscii.o: ascii2petscii.c openfiles.h petscii.h


petscii2ascii: petscii2ascii.o petscii.o openfiles.o

petscii2ascii.o: petscii2ascii.c openfiles.h petscii.h


striploadaddress: striploadaddress.o openfiles.o

striploadaddress.o: striploadaddress.c openfiles.h


ufscr2file: ufscr2file.o petscii.o openfiles.o

ufscr2file.o: ufscr2file.c openfiles.h petscii.h


openfiles.o: openfiles.c openfiles.h

petscii.o: petscii.c petscii.h


install: ascii2petscii petscii2ascii striploadaddress ufscr2file
	cp $+ $(bindir)/

test: test_ufscr2file_file test_ufscr2file_stdout test_petscii

test_ufscr2file_file: ufscr2file
	./ufscr2file testdata/testsrc.d64 test_file.fth
	diff test_file.fth testdata/testsrc.fth

test_ufscr2file_stdout: ufscr2file
	./ufscr2file testdata/testsrc.d64 >test_stdout.fth
	diff test_stdout.fth testdata/testsrc.fth

test_petscii: petscii_test
	./petscii_test

petscii_test: petscii_test.o petscii.o

petscii_test.o: petscii_test.c petscii.h cheat.h
