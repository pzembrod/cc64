
basedir = ../..

c64_rt_files = \
    $(patsubst $(basedir)/runtime/%, c64files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))
c16_rt_files = \
    $(patsubst $(basedir)/runtime/%, c16files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))
x16_rt_files = \
    $(patsubst $(basedir)/runtime/%, x16files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))


cc64srcs_ascii = $(wildcard $(basedir)/src/cc64/*.fth)
cc64srcs_c64 = $(patsubst $(basedir)/src/cc64/%, c64files/%, $(cc64srcs_ascii))

testsrcs_ascii = $(wildcard *.fth)
testsrcs_c64 = $(patsubst %, c64files/%, $(testsrcs_ascii))


tests: libtest.result


libtest.result: libtest.c libtest.golden compile-lib.sh \
    $(basedir)/autostart-c64/cc64.T64 $(c64_rt_files)
	./compile-lib.sh libtest

faketest: $(cc64srcs_c64) $(testsrcs_c64)

clean:
	rm -f c64files/* c16files/* x16files/*
	rm -f libtest.result tmp.result
	rm -f *.out *-result.txt *-generated.c

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

c64files/%.fth: %.fth
	ascii2petscii $< $@
	touch -r $< $@

c64files/%.fth: $(basedir)/src/*/%.fth
	ascii2petscii $< $@
	touch -r $< $@
