
test_results = $(patsubst %-test.c,%-result.txt,$(wildcard *-test.c))
rt_files = $(patsubst ../c64files/%,c64files/%, \
    $(wildcard ../c64files/rt-c64-0801.[hio]))

tests: fasttests

alltests: fasttests slowtests petests

slowtests: separate-tests.result

fasttests: suite.result

petests: pesuite.result

separate-tests.result: $(test_results)
	cat $^ >$@

$(test_results) suite.result: ../emulator/cc64.T64 $(rt_files) *.sh *.h

pesuite.result: ../emulator/cc64pe.T64 $(rt_files) *.sh *.h

$(test_results): %-result.txt: %-test.c %.golden
	./run-test.sh $*

suite.result: *-test.c *.golden
	./perform-suite.sh cc64

pesuite.result: *-test.c *.golden
	./perform-suite.sh cc64pe

clean:
	rm -f c64files/* suite.* separate-tests.result tmp.result
	rm -f *.out *.T64 *-result.txt *-generated.c

c64files/rt-c64-0801.h: ../c64files/rt-c64-0801.h
	test -d c64files || mkdir c64files
	cp $< $@

c64files/rt-c64-0801.i: ../c64files/rt-c64-0801.i
	test -d c64files || mkdir c64files
	cp $< $@

c64files/rt-c64-0801.o: ../c64files/rt-c64-0801.o
	test -d c64files || mkdir c64files
	cp $< $@

c64files/%.h: %.h
	test -d c64files || mkdir c64files
	ascii2petscii $< $@
