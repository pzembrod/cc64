
basedir = ../..

commonsrcs_ascii = $(wildcard $(basedir)/src/common/*.fth)
commonsrcs_c64 = $(patsubst $(basedir)/src/common/%, c64files/%, $(commonsrcs_ascii))
cc64srcs_ascii = $(wildcard $(basedir)/src/cc64/*.fth)
cc64srcs_c64 = $(patsubst $(basedir)/src/cc64/%, c64files/%, $(cc64srcs_ascii))

testsrcs_ascii = $(wildcard *.fth)
testsrcs_c64 = $(patsubst %, c64files/%, $(testsrcs_ascii))

.SECONDARY:

tests: strings-test scanner-test prs-def-test prs-stm-test prs-cgn-test

# Spelled-out test targets for shell tab-complete
profilertest:
prs-cgn-test:
prs-def-test:
prs-stm-test:
scanner-test:
strings-test:

# Actual unified test rule
%test: $(cc64srcs_c64) $(commonsrcs_c64) $(testsrcs_c64)
	./build-run-test.sh $*test

clean:
	rm -f c64files/* c16files/* x16files/*
	rm -f *.result *.out

c64files/%.fth: %.fth
	ascii2petscii $< $@
	touch -r $< $@

c64files/%.fth: $(basedir)/src/*/%.fth
	ascii2petscii $< $@
	touch -r $< $@
