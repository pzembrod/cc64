
basedir = ../..

commonsrcs_ascii = $(wildcard $(basedir)/src/common/*.fth)
commonsrcs_c64 = $(patsubst $(basedir)/src/common/%, c64files/%, $(commonsrcs_ascii))
cc64srcs_ascii = $(wildcard $(basedir)/src/cc64/*.fth)
cc64srcs_c64 = $(patsubst $(basedir)/src/cc64/%, c64files/%, $(cc64srcs_ascii))

testsrcs_ascii = $(wildcard *.fth)
testsrcs_c64 = $(patsubst %, c64files/%, $(testsrcs_ascii))


tests: faketest


faketest: $(cc64srcs_c64) $(commonsrcs_c64) $(testsrcs_c64)
	./build-test.sh

clean:
	rm -f c64files/* c16files/* x16files/*
	rm -f *.result *.out

c64files/%.fth: %.fth
	ascii2petscii $< $@
	touch -r $< $@

c64files/%.fth: $(basedir)/src/*/%.fth
	ascii2petscii $< $@
	touch -r $< $@
