

rt_files = c64files/rt-c64-0801.h c64files/rt-c64-0801.i \
  c64files/rt-c64-0801.o c64files/kernal-io.h c64files/test.h

all: helloworld.test helloworld-3.test

clean:
	rm -f c64files/*
	rm -f *.out *.T64

c64files/rt-c64-0801.h: ../rt-c64-0801.h
	ascii2petscii $< $@

c64files/rt-c64-0801.i: ../rt-c64-0801.i
	cp $< $@

c64files/rt-c64-0801.o: ../rt-c64-0801.o
	cp $< $@

c64files/%.h: %.h
	ascii2petscii $< $@

helloworld.test: helloworld.c  ../cc64v05.T64 $(rt_files)
	./run-test.sh helloworld

helloworld-3.test: helloworld-3.c  ../cc64v05.T64 $(rt_files)
	./run-test.sh helloworld-3

