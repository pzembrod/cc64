
# cc64 sources and binaries
cc64srcs_ascii = $(wildcard src/cc64/*.fth)
cc64srcs_c64 = $(patsubst src/cc64/%, c64files/%, $(cc64srcs_ascii))
peddisrcs_ascii = $(wildcard src/peddi/*.fth)
peddisrcs_c64 = $(patsubst src/peddi/%, c64files/%, $(peddisrcs_ascii))
cc64_binaries = cc64 cc64pe peddi
cc64_t64_files = $(patsubst %, emulator/%.T64, $(cc64_binaries))

# c64files content
rt_files = rt-c64-0801.h rt-c64-0801.i rt-c64-0801.o
sample_files = helloworld.c kernal-io.c
c64dir_content = $(cc64_binaries) $(rt_files) $(sample_files) c-charset
c64dir_files = $(patsubst %, c64files/% , $(c64dir_content))

# Forth binaries
forth_binaries = devenv-uF83 uF83-382-c64 uf-build-base
forth_t64_files = $(patsubst %, emulator/%.T64, $(forth_binaries))


all: cc64 $(c64dir_files) c64files.zip c64files.d64 etc

cc64: $(cc64_t64_files)

c64files.zip: $(c64dir_files)
	rm -f $@
	zip -r $@ $(c64dir_files)

c64files.d64: $(c64dir_files)
	rm -f $@
	c1541 -format cc64v05,cc d64 $@
	c1541 -attach $@ $(patsubst %, -write c64files/%, $(cc64_binaries))
	c1541 -attach $@ -write c64files/rt-c64-0801.h rt-c64-0801.h,s
	c1541 -attach $@ -write c64files/rt-c64-0801.i
	c1541 -attach $@ -write c64files/rt-c64-0801.o
	c1541 -attach $@ -write c64files/c-charset
	c1541 -attach $@ -write c64files/helloworld.c helloworld.c,s
	c1541 -attach $@ -write c64files/kernal-io.c kernal-io.c,s

etc: $(forth_t64_files) emulator/c-char-rom-gen


clean:
	rm -f c64files/*.fth tmp/*
	$(MAKE) -C tests clean
	$(MAKE) -C tests/peddi clean

veryclean: clean
	rm -f c64files/*
	rm -f c64files.d64 c64files.zip
	rm -f emulator/*.T64 emulator/c-char-rom-gen
	rm -f runtime/*


test: cc64 fasttests

alltests:
	$(MAKE) -C tests alltests

fasttests:
	$(MAKE) -C tests fasttests

slowtests:
	$(MAKE) -C tests slowtests


# cc64 build rules

c64files/cc64: $(cc64srcs_c64) \
 build/build-cc64.sh emulator/uf-build-base.T64
	build/build-cc64.sh

c64files/cc64pe: $(cc64srcs_c64) $(peddisrcs_c64) \
 build/build-cc64pe.sh emulator/uf-build-base.T64
	build/build-cc64pe.sh

c64files/peddi: $(peddisrcs_c64) \
 build/build-peddi.sh emulator/uf-build-base.T64
	build/build-peddi.sh


# cc64 T64 tape images

emulator/cc64.T64: c64files/cc64

emulator/cc64pe.T64: c64files/cc64pe

emulator/peddi.T64: c64files/peddi


# Forth T64 tape images

emulator/devenv-uF83.T64: forth/devenv-uF83

emulator/uf-build-base.T64: forth/uf-build-base

emulator/uF83-382-c64.T64: forth/uF83-382-c64

emulator/c64-vf-390.T64: forth/c64-vf-390


# Runtime module rules

c64files/rt-c64-0801.o runtime/rt-c64-0801.h: \
    src/runtime/rt-c64-0801.a build/generate_pragma_cc64.awk
	test -d tmp || mkdir tmp
	acme -f cbm -l tmp/rt-c64-0801.sym -o c64files/rt-c64-0801.o \
	  src/runtime/rt-c64-0801.a
	awk -f build/generate_pragma_cc64.awk -F '$$' tmp/rt-c64-0801.sym \
	  > runtime/rt-c64-0801.h

c64files/rt-c64-0801.h: runtime/rt-c64-0801.h
	ascii2petscii $< $@
	touch -r $< $@

c64files/rt-c64-0801.i:
	awk 'BEGIN{ printf("\x00\x90");}' > $@
	# An empty binary file with (arbitrary) load address $9000
	# Might be worth encoding in an asm source for clarity.


# Charset rules

c64files/c-charset: src/runtime/c-charset.a
	test -d tmp || mkdir tmp
	acme -f cbm -l tmp/c-charset.sym -o $@ $<

emulator/c-char-rom-gen: src/runtime/c-char-rom-gen.a
	acme -f cbm -o $@ $<

emulator/c-chargen: emulator/c-char-rom-gen
	x64 -virtualdev +truedrive -drive8type 1541 -fs8 emulator \
	-keybuf 'load"c-char-rom-gen",8\nrun\n'


# Generic T64 tape image rules

emulator/%.T64: c64files/%
	bin2t64 $< $@

emulator/%.T64: forth/%
	bin2t64 $< $@


# Rules, mostly generic, to populate c64files/

c64files/%.fth: src/*/%.fth
	ascii2petscii $< $@
	touch -r $< $@

c64files/%.c: src/*/%.c
	ascii2petscii $< $@
	touch -r $< $@
