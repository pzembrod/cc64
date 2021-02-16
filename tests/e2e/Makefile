
basedir = ../..

test_names = $(patsubst %-test.c, %, $(wildcard *-test.c))
test_results_c64_c64 = $(patsubst %, %-c64_c64.result, $(test_names))
test_results_c64_c16 = $(patsubst %, %-c64_c16.result, $(test_names))
test_results_c64_x16 = $(patsubst %, %-c64_x16.result, $(test_names))
test_results_c16_c64 = $(patsubst %, %-c16_c64.result, $(test_names))
test_results_c16_c16 = $(patsubst %, %-c16_c16.result, $(test_names))
test_results_c16_x16 = $(patsubst %, %-c16_x16.result, $(test_names))
test_results_x16_c64 = $(patsubst %, %-x16_c64.result, $(test_names))
test_results_x16_c16 = $(patsubst %, %-x16_c16.result, $(test_names))
test_results_x16_x16 = $(patsubst %, %-x16_x16.result, $(test_names))

test_results_c64_hosted = $(test_results_c64_c64) $(test_results_c64_c16) $(test_results_c64_x16)
test_results_c16_hosted = $(test_results_c16_c64) $(test_results_c16_c16) $(test_results_c16_x16)
test_results_x16_hosted = $(test_results_x16_c64) $(test_results_x16_c16) $(test_results_x16_x16)

suite_suffixes = $(patsubst %, %.result, c64 c16 x16)
suite_c64_suffixes = $(patsubst %, suite-c64_%, $(suite_suffixes))
suite_c16_suffixes = $(patsubst %, suite-c16_%, $(suite_suffixes))
suite_x16_suffixes = $(patsubst %, suite-x16_%, $(suite_suffixes))
suite_results_c64_hosted = \
    $(patsubst %, cc64-% cc64pe-%, $(suite_c64_suffixes))
suite_results_c16_hosted = \
    $(patsubst %, cc64-% cc64pe-%, $(suite_c16_suffixes))
suite_results_x16_hosted = \
    $(patsubst %, cc64-%, $(suite_x16_suffixes))

c64_rt_files = \
    $(patsubst $(basedir)/runtime/%, c64files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))
c16_rt_files = \
    $(patsubst $(basedir)/runtime/%, c16files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))
x16_rt_files = \
    $(patsubst $(basedir)/runtime/%, x16files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))

tests: fasttests64

alltests: fasttests slowtests petests

fasttests64: cc64-suite-c64_c64.result

fasttests: \
  cc64-suite-c64_c64.result \
  cc64-suite-c16_c16.result \
  cc64-suite-x16_x16.result

slowtests: separate-tests-c64_c64.result

petests: cc64pe-suite-c64_c64.result

allcrosstests: fastcrosstests slowcrosstests pecrosstests

fastcrosstests: \
  cc64-suite-c64_c64.result \
  cc64-suite-c64_c16.result \
  cc64-suite-c64_x16.result \
  cc64-suite-c16_c64.result \
  cc64-suite-c16_c16.result \
  cc64-suite-c16_x16.result \
  cc64-suite-x16_c64.result \
  cc64-suite-x16_c16.result \
  cc64-suite-x16_x16.result

slowcrosstests: \
  separate-tests-c64_c64.result \
  separate-tests-c64_c16.result \
  separate-tests-c64_x16.result \
  separate-tests-c16_c64.result \
  separate-tests-c16_c16.result \
  separate-tests-c16_x16.result \
  separate-tests-x16_c64.result \
  separate-tests-x16_c16.result \
  separate-tests-x16_x16.result

pecrosstests: \
  cc64pe-suite-c64_c64.result \
  cc64pe-suite-c16_c16.result \
  cc64pe-suite-c64_c16.result \
  cc64pe-suite-c16_c64.result

separate-tests-c64_c64.result: $(test_results_c64_c64)
	cat $^ >$@

separate-tests-c64_c16.result: $(test_results_c64_c16)
	cat $^ >$@

separate-tests-c64_x16.result: $(test_results_c64_x16)
	cat $^ >$@

separate-tests-c16_c64.result: $(test_results_c16_c64)
	cat $^ >$@

separate-tests-c16_c16.result: $(test_results_c16_c16)
	cat $^ >$@

separate-tests-c16_x16.result: $(test_results_c16_x16)
	cat $^ >$@

separate-tests-x16_c64.result: $(test_results_x16_c64)
	cat $^ >$@

separate-tests-x16_c16.result: $(test_results_x16_c16)
	cat $^ >$@

separate-tests-x16_x16.result: $(test_results_x16_x16)
	cat $^ >$@

$(test_results_c64_hosted) $(suite_results_c64_hosted): \
    $(basedir)/autostart-c64/cc64.T64 $(c64_rt_files) *.sh *.h

$(test_results_c16_hosted) $(suite_results_c16_hosted): \
    $(basedir)/autostart-c16/cc64.T64 $(c16_rt_files) *.sh *.h

$(test_results_x16_hosted) $(suite_results_x16_hosted): \
    x16files/cc64 $(x16_rt_files) *.sh *.h

$(test_results_c64_c64): %-c64_c64.result: %-test.c %.golden
	./compile-run-test.sh $* c64_c64

$(test_results_c64_c16): %-c64_c16.result: %-test.c %.golden
	./compile-run-test.sh $* c64_c16

$(test_results_c64_x16): %-c64_x16.result: %-test.c %.golden
	./compile-run-test.sh $* c64_x16

$(test_results_c16_c64): %-c16_c64.result: %-test.c %.golden
	./compile-run-test.sh $* c16_c64

$(test_results_c16_c16): %-c16_c16.result: %-test.c %.golden
	./compile-run-test.sh $* c16_c16

$(test_results_c16_x16): %-c16_x16.result: %-test.c %.golden
	./compile-run-test.sh $* c16_x16

$(test_results_x16_c64): %-x16_c64.result: %-test.c %.golden
	./compile-run-test.sh $* x16_c64

$(test_results_x16_c16): %-x16_c16.result: %-test.c %.golden
	./compile-run-test.sh $* x16_c16

$(test_results_x16_x16): %-x16_x16.result: %-test.c %.golden
	./compile-run-test.sh $* x16_x16


cc64-suite-%.result: *-test.c *.golden
	./compile-run-suite.sh cc64 $*

cc64pe-suite-%.result: *-test.c *.golden
	./compile-run-suite.sh cc64pe $*


cc64-suite-c64_x16.result: $(basedir)/emulator/sdcard.img

cc64pe-suite-c64_x16.result: $(basedir)/emulator/sdcard.img

cc64-suite-c16_x16.result: $(basedir)/emulator/sdcard.img

cc64pe-suite-c16_x16.result: $(basedir)/emulator/sdcard.img

cc64-suite-x16_x16.result: $(basedir)/emulator/sdcard.img

$(basedir)/emulator/sdcard.img: $(basedir)/emulator/sdcard.sfdisk
	$(basedir)/emulator/mk-sdcard.sh $< $@

clean:
	rm -f c64files/* c16files/* x16files/*
	rm -f separate-tests-c??_c??.result libtest.result tmp.result
	rm -f cc64-suite-[cx]??_[cx]??.* cc64pe-suite-[cx]??_[cx]??.*
	rm -f suite.joined-*
	rm -f *.out *.T64 *.result *-generated.c

c64files/rt-%: $(basedir)/c64files/rt-%
	test -d c64files || mkdir c64files
	cp $< $@

c16files/rt-%: $(basedir)/c16files/rt-%
	test -d c16files || mkdir c16files
	cp $< $@

x16files/rt-%: $(basedir)/x16files/rt-%
	test -d x16files || mkdir x16files
	cp $< $@

c64files/%.h: %.h
	test -d c64files || mkdir c64files
	ascii2petscii $< $@

c16files/%.h: %.h
	test -d c16files || mkdir c16files
	ascii2petscii $< $@

x16files/%.h: %.h
	test -d x16files || mkdir x16files
	ascii2petscii $< $@

x16files/cc64: $(basedir)/x16files/cc64
	test -d x16files || mkdir x16files
	cp $< $@
