
basedir = ../..

suite_suffixes = $(patsubst %, %.result, c64 c16 x16)
suite_c64_suffixes = $(patsubst %, suite-c64_%, $(suite_suffixes))
suite_c16_suffixes = $(patsubst %, suite-c16_%, $(suite_suffixes))
suite_x16_suffixes = $(patsubst %, suite-x16_%, $(suite_suffixes))
suite_results_c64_hosted = \
    $(patsubst %, lib-%, $(suite_c64_suffixes)) \
    $(patsubst %, libc-%, $(suite_c64_suffixes))
suite_results_c16_hosted = \
    $(patsubst %, lib-%, $(suite_c16_suffixes)) \
    $(patsubst %, libc-%, $(suite_c16_suffixes))
suite_results_x16_hosted = \
    $(patsubst %, lib-%, $(suite_x16_suffixes)) \
    $(patsubst %, libc-%, $(suite_x16_suffixes))

c64_rt_files = \
    $(patsubst $(basedir)/runtime/%, c64files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))
c16_rt_files = \
    $(patsubst $(basedir)/runtime/%, c16files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))
x16_rt_files = \
    $(patsubst $(basedir)/runtime/%, x16files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))

lib_files = $(sort $(wildcard $(basedir)/src/lib/*.c))

tests: libtests64

alltests: libtests

libctests64: libc-suite-c64_c64.result

libctests: \
  libc-suite-c64_c64.result \
  libc-suite-c16_c16.result \
  libc-suite-x16_x16.result

libtests64: lib-suite-c64_c64.result

libtests: \
  lib-suite-c64_c64.result \
  lib-suite-c16_c16.result \
  lib-suite-x16_x16.result

libcrosstests: \
  lib-suite-c64_c64.result \
  lib-suite-c64_c16.result \
  lib-suite-c64_x16.result \
  lib-suite-c16_c64.result \
  lib-suite-c16_c16.result \
  lib-suite-c16_x16.result \
  lib-suite-x16_c64.result \
  lib-suite-x16_c16.result \
  lib-suite-x16_x16.result


lib-suite-%.result: */*-test.c */*.golden
	./compile-run-suite.sh lib $*

libc-suite-%.result: */*-test.c */*.golden
	./compile-run-suite.sh libc $*

lib.c: $(lib_files)
	cat $(lib_files) >$@

libc.c: $(basedir)/lib/libc.c
	cp $< $@

$(suite_results_c64_hosted): c64files/lib.c c64files/libc.c \
    $(basedir)/autostart-c64/cc64.T64 $(c64_rt_files) *.sh *.shlib *.h

$(suite_results_c16_hosted): c16files/lib.c c16files/libc.c \
    $(basedir)/autostart-c16/cc64.T64 $(c16_rt_files) *.sh *.shlib *.h

$(suite_results_x16_hosted): x16files/lib.c x16files/libc.c \
    x16files/cc64 $(x16_rt_files) *.sh *.shlib *.h



clean:
	rm -f c64files/* c16files/* x16files/*
	rm -f cc64-suite-[cx]??_[cx]??.* cc64pe-suite-[cx]??_[cx]??.*
	rm -f suite.joined-* lib.c libc.c
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

c64files/%.c: %.c
	test -d c64files || mkdir c64files
	ascii2petscii $< $@

c16files/%.c: %.c
	test -d c16files || mkdir c16files
	ascii2petscii $< $@

x16files/%.c: %.c
	test -d x16files || mkdir x16files
	ascii2petscii $< $@

x16files/cc64: $(basedir)/x16files/cc64
	test -d x16files || mkdir x16files
	cp $< $@
