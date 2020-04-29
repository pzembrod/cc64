

rt_files = c64files/rt-c64-0801.h c64files/rt-c64-0801.i c64files/rt-c64-0801.o

all: helloworld.test

c64files/rt-c64-0801.h: ../rt-c64-0801.h
	ascii2petscii $< $@

c64files/rt-c64-0801.i: ../rt-c64-0801.i
	cp $< $@

c64files/rt-c64-0801.o: ../rt-c64-0801.o
	cp $< $@

helloworld.test: helloworld.c kernal-io.h ../cc64v05.T64 $(rt_files)
	ascii2petscii helloworld.c c64files/helloworld.c
	ascii2petscii kernal-io.h c64files/kernal-io.h
	rm -f c64files/helloworld
	./compile-in-vice.sh "cc helloworld.c\ndos s0:notdone\n"
	bin2t64 c64files/helloworld helloworld.T64
	rm -f c64files/helloworld.out
	./test-in-vice.sh 'open 1,8,15,"s0:notdone": close 1\n'
	petscii2ascii c64files/helloworld.out helloworld.out
	diff helloworld.golden helloworld.out
