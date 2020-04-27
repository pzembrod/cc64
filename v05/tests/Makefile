

rt_files = c64files/rt-c64-0801.h c64files/rt-c64-0801.i c64files/rt-c64-0801.o

all: rt

rt: $(rt_files)

c64files/rt-c64-0801.h: ../rt-c64-0801.h
	ascii2petscii $< $@

c64files/rt-c64-0801.i: ../rt-c64-0801.i
	cp $< $@

c64files/rt-c64-0801.o: ../rt-c64-0801.h
	cp $< $@

c64files/helloworld: c64files/helloworld.c c64files/compile.fth c64files/kernal-io.h ../cc64v05.T64
	./compile-in-vice.sh "only forth include compile.fth\n"

helloworld.T64: c64files/helloworld

c64files/kernal-io.h: kernal-io.h

c64files/helloworld.c: helloworld.c

c64files/%.c: %.c
	ascii2petscii $< $@

c64files/%.h: %.h
	ascii2petscii $< $@

c64files/%.fth: %.fth
	ascii2petscii $< $@

%.T64: c64files/%
	bin2t64 $< $@
