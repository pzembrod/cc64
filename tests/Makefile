
test_names = $(patsubst %-test.c, %, $(wildcard *-test.c))
test_results_c64_c64 = $(patsubst %, %-c64_c64-result.txt, $(test_names))
test_results_c64_c16 = $(patsubst %, %-c64_c16-result.txt, $(test_names))
test_results_c16_c64 = $(patsubst %, %-c16_c64-result.txt, $(test_names))
test_results_c16_c16 = $(patsubst %, %-c16_c16-result.txt, $(test_names))

test_results_c64_hosted = $(test_results_c64_c64) $(test_results_c64_c16)
test_results_c16_hosted = $(test_results_c16_c64) $(test_results_c16_c16)

c64_rt_files = $(patsubst ../runtime/%, c64files/%, \
    $(wildcard ../runtime/rt-*.[hio]))
c16_rt_files = $(patsubst ../runtime/%, c16files/%, \
    $(wildcard ../runtime/rt-*.[hio]))

tests: fasttests

alltests: fasttests slowtests petests

slowtests: separate-tests-c64_c64.result

fasttests: cc64-suite-c64_c64.result

petests: cc64pe-suite-c64_c64.result

slowcrosstests: \
  separate-tests-c64_c64.result \
  separate-tests-c16_c16.result \
  separate-tests-c64_c16.result \
  separate-tests-c16_c64.result

separate-tests-c64_c64.result: $(test_results_c64_c64)
	cat $^ >$@

separate-tests-c64_c16.result: $(test_results_c64_c16)
	cat $^ >$@

separate-tests-c16_c64.result: $(test_results_c16_c64)
	cat $^ >$@

separate-tests-c16_c16.result: $(test_results_c16_c16)
	cat $^ >$@

$(test_results_c64_hosted) cc64-suite-c64_*.result cc64pe-pesuite.result: \
  $(c64_rt_files) *.sh *.h

$(test_results_c16_hosted) cc64-suite-c16_*.result cc64pe-pesuite.result: \
  $(c16_rt_files) *.sh *.h

$(test_results_c64_hosted) cc64-suite-c64_*.result: ../autostart-c64/cc64.T64

$(test_results_c16_hosted) cc64-suite-c16_*.result: ../autostart-c16/cc64.T64

cc64pe-suite-c64_*.result: ../autostart-c64/cc64pe.T64

cc64pe-suite-c16_*.result: ../autostart-c16/cc64pe.T64

$(test_results_c64_c64): %-c64_c64-result.txt: %-test.c %.golden
	./run-test.sh $* c64_c64

$(test_results_c64_c16): %-c64_c16-result.txt: %-test.c %.golden
	./run-test.sh $* c64_c16

$(test_results_c16_c64): %-c16_c64-result.txt: %-test.c %.golden
	./run-test.sh $* c16_c64

$(test_results_c16_c16): %-c16_c16-result.txt: %-test.c %.golden
	./run-test.sh $* c16_c16

cc64-suite-%.result: *-test.c *.golden
	./perform-suite.sh cc64 $*

cc64pe-suite-%.result: *-test.c *.golden
	./perform-suite.sh cc64pe $*

clean:
	rm -f c64files/* c16files/* separate-tests-c??_c??.result tmp.result
	rm -f cc64-suite-c??_c??.* cc64pe-suite-c??_c??.* suite.joined-*
	rm -f *.out *.T64 *-result.txt *-generated.c

c64files/rt-%: ../c64files/rt-%
	test -d c64files || mkdir c64files
	cp $< $@

c16files/rt-%: ../c16files/rt-%
	test -d c16files || mkdir c16files
	cp $< $@

c64files/%.h: %.h
	test -d c64files || mkdir c64files
	ascii2petscii $< $@

c16files/%.h: %.h
	test -d c16files || mkdir c16files
	ascii2petscii $< $@
