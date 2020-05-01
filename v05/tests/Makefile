
tests = $(patsubst %-test.c,%-result.txt,$(wildcard *-test.c))
rt_files = $(patsubst ../%,c64files/%,$(wildcard ../rt-c64-0801.[hio]))

all: $(tests)

$(tests): ../cc64v05.T64 $(rt_files) *.sh *.h

$(tests): %-result.txt: %-test.c %.golden
	./do-test.sh $*

clean:
	rm -f c64files/*
	rm -f *.out *.T64 *-result.txt *-generated.c tmp.result

c64files/rt-c64-0801.h: ../rt-c64-0801.h
	ascii2petscii $< $@

c64files/rt-c64-0801.i: ../rt-c64-0801.i
	cp $< $@

c64files/rt-c64-0801.o: ../rt-c64-0801.o
	cp $< $@
