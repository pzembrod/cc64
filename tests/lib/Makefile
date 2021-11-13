
basedir = ../..

suite_suffixes = $(patsubst %, %.result, c64 c16 x16)
suite_c64_suffixes = $(patsubst %, suite-c64_%, $(suite_suffixes))
suite_c16_suffixes = $(patsubst %, suite-c16_%, $(suite_suffixes))
suite_x16_suffixes = $(patsubst %, suite-x16_%, $(suite_suffixes))
suite_results_c64_hosted = \
    $(patsubst %, ctype-%, $(suite_c64_suffixes)) \
    $(patsubst %, stdio-%, $(suite_c64_suffixes)) \
    $(patsubst %, stdlib-%, $(suite_c64_suffixes)) \
    $(patsubst %, string-%, $(suite_c64_suffixes)) \
    $(patsubst %, strmem-%, $(suite_c64_suffixes))
suite_results_c16_hosted = \
    $(patsubst %, ctype-%, $(suite_c16_suffixes)) \
    $(patsubst %, stdio-%, $(suite_c16_suffixes)) \
    $(patsubst %, stdlib-%, $(suite_c16_suffixes)) \
    $(patsubst %, string-%, $(suite_c16_suffixes)) \
    $(patsubst %, strmem-%, $(suite_c16_suffixes))
suite_results_x16_hosted = \
    $(patsubst %, ctype-%, $(suite_x16_suffixes)) \
    $(patsubst %, stdio-%, $(suite_x16_suffixes)) \
    $(patsubst %, stdlib-%, $(suite_x16_suffixes)) \
    $(patsubst %, string-%, $(suite_x16_suffixes)) \
    $(patsubst %, strmem-%, $(suite_x16_suffixes))

c64_rt_files = \
    $(patsubst $(basedir)/runtime/%, c64files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))
c16_rt_files = \
    $(patsubst $(basedir)/runtime/%, c16files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))
x16_rt_files = \
    $(patsubst $(basedir)/runtime/%, x16files/%, $(wildcard $(basedir)/runtime/rt-*.[hio]))

c64_lib_files = \
    $(patsubst $(basedir)/lib/%, c64files/%, $(wildcard $(basedir)/lib/*.[hio]))
c16_lib_files = \
    $(patsubst $(basedir)/lib/%, c16files/%, $(wildcard $(basedir)/lib/*.[hio]))
x16_lib_files = \
    $(patsubst $(basedir)/lib/%, x16files/%, $(wildcard $(basedir)/lib/*.[hio]))


tests: tests64

alltests: \
  ctypetests \
  stdiotests \
  stdlibtests \
  strmemtests \
  stringtests

allcrosstests: \
  ctypecrosstests \
  stdiocrosstests \
  stdlibcrosstests \
  strmemcrosstests \
  stringcrosstests

tests64: \
  ctype-suite-c64_c64.result \
  stdio-suite-c64_c64.result \
  stdlib-suite-c64_c64.result \
  strmem-suite-c64_c64.result \
  string-suite-c64_c64.result

ctypetests: \
  ctype-suite-c64_c64.result \
  ctype-suite-c16_c16.result \
  ctype-suite-x16_x16.result

stdiotests: \
  stdio-suite-c64_c64.result \
  stdio-suite-c16_c16.result \
  stdio-suite-x16_x16.result

stdlibtests: \
  stdlib-suite-c64_c64.result \
  stdlib-suite-c16_c16.result \
  stdlib-suite-x16_x16.result

strmemtests: \
  strmem-suite-c64_c64.result \
  strmem-suite-c16_c16.result \
  strmem-suite-x16_x16.result

stringtests: \
  string-suite-c64_c64.result \
  string-suite-c16_c16.result \
  string-suite-x16_x16.result

ctypecrosstests: \
  ctype-suite-c64_c64.result \
  ctype-suite-c64_c16.result \
  ctype-suite-c64_x16.result \
  ctype-suite-c16_c64.result \
  ctype-suite-c16_c16.result \
  ctype-suite-c16_x16.result \
  ctype-suite-x16_c64.result \
  ctype-suite-x16_c16.result \
  ctype-suite-x16_x16.result

stdiocrosstests: \
  stdio-suite-c64_c64.result \
  stdio-suite-c64_c16.result \
  stdio-suite-c64_x16.result \
  stdio-suite-c16_c64.result \
  stdio-suite-c16_c16.result \
  stdio-suite-c16_x16.result \
  stdio-suite-x16_c64.result \
  stdio-suite-x16_c16.result \
  stdio-suite-x16_x16.result

stdlibcrosstests: \
  stdlib-suite-c64_c64.result \
  stdlib-suite-c64_c16.result \
  stdlib-suite-c64_x16.result \
  stdlib-suite-c16_c64.result \
  stdlib-suite-c16_c16.result \
  stdlib-suite-c16_x16.result \
  stdlib-suite-x16_c64.result \
  stdlib-suite-x16_c16.result \
  stdlib-suite-x16_x16.result

strmemcrosstests: \
  strmem-suite-c64_c64.result \
  strmem-suite-c64_c16.result \
  strmem-suite-c64_x16.result \
  strmem-suite-c16_c64.result \
  strmem-suite-c16_c16.result \
  strmem-suite-c16_x16.result \
  strmem-suite-x16_c64.result \
  strmem-suite-x16_c16.result \
  strmem-suite-x16_x16.result

stringcrosstests: \
  string-suite-c64_c64.result \
  string-suite-c64_c16.result \
  string-suite-c64_x16.result \
  string-suite-c16_c64.result \
  string-suite-c16_c16.result \
  string-suite-c16_x16.result \
  string-suite-x16_c64.result \
  string-suite-x16_c16.result \
  string-suite-x16_x16.result


ctype-suite-%.result: ctype/*  *.sh *.shlib *.h
	./compile-run-suite.sh ctype $*

stdio-suite-%.result: stdio/* *.sh *.shlib *.h
	./compile-run-suite.sh stdio $*

stdlib-suite-%.result: stdlib/* stdlib/rand-expect.c *.sh *.shlib *.h
	./compile-run-suite.sh stdlib $* stdlib/rand-expect.c

strmem-suite-%.result: strmem/* *.sh *.shlib *.h
	./compile-run-suite.sh strmem $*

string-suite-%.result: string/* *.sh *.shlib *.h
	./compile-run-suite.sh string $*

$(suite_results_c64_hosted): $(c64_lib_files) \
    $(basedir)/autostart-c64/cc64.T64

$(suite_results_c16_hosted): $(c16_lib_files) \
    $(basedir)/autostart-c16/cc64.T64

$(suite_results_x16_hosted): $(x16_lib_files) \
    x16files/cc64

stdlib/rand-expect.c: rand-oracle rand-oracle.sh
	./rand-oracle.sh $@

rand-oracle: rand-oracle.c

clean:
	rm -f c64files/* c16files/* x16files/*
	rm -f *-suite-[cx]??_[cx]??.*
	rm -f suite.joined-*
	rm -f *.out *.out? *.T64 *.result *-generated.c

c64files/%: $(basedir)/c64files/%
	test -d c64files || mkdir c64files
	cp $< $@

c16files/%: $(basedir)/c16files/%
	test -d c16files || mkdir c16files
	cp $< $@

x16files/%: $(basedir)/x16files/%
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
