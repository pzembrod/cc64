# Where to put the executable for the command 'gcc'.
bindir = $(HOME)/bin

all: ascii2petscii petscii2ascii ufscr2file

clean:
	rm -f ascii2petscii petscii2ascii ufscr2file petscii_test *.o *.fth

ascii2petscii: ascii2petscii.o petscii.o

ascii2petscii.o: ascii2petscii.c

petscii2ascii: petscii2ascii.o petscii.o

petscii2ascii.o: petscii2ascii.c

ufscr2file: ufscr2file.o petscii.o

ufscr2file.o: ufscr2file.c

petscii.o: petscii.c

install: ascii2petscii petscii2ascii ufscr2file
	cp $+ $(bindir)/

test: test_ufscr2file_file test_ufscr2file_stdout test_petscii

test_ufscr2file_file: ufscr2file
	./ufscr2file testdata/testsrc.d64 file.fth
	diff file.fth testdata/testsrc.fth

test_ufscr2file_stdout: ufscr2file
	./ufscr2file testdata/testsrc.d64 >stdout.fth
	diff stdout.fth testdata/testsrc.fth

test_petscii: petscii_test
	./petscii_test

petscii_test: petscii_test.o petscii.o

petscii_test.o: petscii_test.c petscii.h cheat.h
