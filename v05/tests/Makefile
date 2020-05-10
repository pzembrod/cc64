
test_results = $(patsubst %-test.c,%-result.txt,$(wildcard *-test.c))
rt_files = $(patsubst ../%,c64files/%,$(wildcard ../rt-c64-0801.[hio]))

alltests: fasttests slowtests

slowtests: separate-tests.result

fasttests: suite.result

separate-tests.result: $(test_results)
	cat $^ >$@

$(test_results) suite.result: ../cc64v05.T64 $(rt_files) *.sh *.h

$(test_results): %-result.txt: %-test.c %.golden
	./run-test.sh $*

suite.result: *-test.c *.golden
	./perform-suite.sh

clean:
	rm -f c64files/* suite.* separate-tests.result tmp.result
	rm -f *.out *.T64 *-result.txt *-generated.c

c64files/rt-c64-0801.h: ../rt-c64-0801.h
	ascii2petscii $< $@

c64files/rt-c64-0801.i: ../rt-c64-0801.i
	cp $< $@

c64files/rt-c64-0801.o: ../rt-c64-0801.o
	cp $< $@

c64files/%.h: %.h
	ascii2petscii $< $@
