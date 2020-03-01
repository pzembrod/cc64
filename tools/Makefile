# Where to put the executable for the command 'gcc'.
bindir = $(HOME)/bin

all: ufscr2file

ufscr2file: ufscr2file.o petscii.o

ufscr2file.o: ufscr2file.c

petscii.o: petscii.c

install: ufscr2file
	cp $+ $(bindir)/

test: test_ufscr2file_file test_ufscr2file_stdout

test_ufscr2file_file: ufscr2file
	./ufscr2file testdata/testsrc.d64 file.fth
	diff file.fth testdata/testsrc.fth

test_ufscr2file_stdout: ufscr2file
	./ufscr2file testdata/testsrc.d64 >stdout.fth
	diff stdout.fth testdata/testsrc.fth
