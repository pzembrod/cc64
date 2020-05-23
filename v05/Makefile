
# cc64 sources and binaries
cc64srcs_d64 = src/cc64src1.d64 src/cc64src2.d64
cc64srcs_fth = $(wildcard src/cc64/*.fth)
cc64srcs_petscii = $(patsubst src/cc64/%, c64files/%, $(cc64srcs_fth))
cc64srcs = $(cc64srcs_d64) $(cc64srcs_petscii)
peddisrc_d64 = src/peddi_src.d64
peddisrcs_fth = $(wildcard src/peddi/*.fth)
peddisrcs_petscii = $(patsubst src/peddi/%, c64files/%, $(peddisrcs_fth))
peddisrcs = $(peddisrc_d64) $(peddisrcs_petscii)
d64_fth_files = $(patsubst %.d64, %.fth, $(cc64srcs_d64) $(peddisrc_d64))
cc64_binaries = cc64v05 cc64v05pe peddi03
cc64_t64_files = $(patsubst %, %.T64, $(cc64_binaries))

# Forth binaries
etc_t64_files = devenv-uF83.T64 uf-build-base.T64

# cc64 runtime files
rt_files = rt-c64-0801.h rt-c64-0801.i rt-c64-0801.o
sample_files = helloworld.c kernal-io.c
c64dir_files = $(rt_files) $(sample_files) c-charset
zipfile_content = $(patsubst %, c64files/% , \
  $(c64dir_files) $(cc64_binaries))


all: cc64 c64dir c64files.zip c64files.d64 etc

cc64: cc64src $(cc64_t64_files)

cc64src: $(d64_fth_files)

c64dir: $(patsubst %, c64files/% , $(c64dir_files))

c64files.zip: $(zipfile_content)
	rm -f $@
	zip -r $@ $(zipfile_content)

c64files.d64: $(zipfile_content)
	rm -f $@
	c1541 -format cc64v05,cc d64 $@
	c1541 -attach $@ $(patsubst %, -write c64files/%, $(cc64_binaries))
	c1541 -attach $@ -write c64files/rt-c64-0801.h rt-c64-0801.h,s
	c1541 -attach $@ -write c64files/rt-c64-0801.i
	c1541 -attach $@ -write c64files/rt-c64-0801.o
	c1541 -attach $@ -write c64files/c-charset
	c1541 -attach $@ -write c64files/helloworld.c helloworld.c,s
	c1541 -attach $@ -write c64files/kernal-io.c kernal-io.c,s

etc: $(etc_t64_files) c-char-rom-gen


clean:
	rm -f rt-c64-0801.sym c-charset.sym c64files/*.fth
	$(MAKE) -C tests clean

veryclean: clean
	rm -f rt-c64-0801.[hio] rt-c64-0801.sym
	rm -f c-charset c-char-rom-gen
	rm -f c64files/cc64v05 c64files/cc64v05pe c64files/peddi03
	rm -f cc64v05.T64 cc64v05pe.T64 peddi03.T64
	rm -f c64files.d64 c64files.zip


test: cc64 fasttests

alltests:
	$(MAKE) -C tests alltests

fasttests:
	$(MAKE) -C tests fasttests

slowtests:
	$(MAKE) -C tests slowtests


# cc64 build rules

c64files/cc64v05: $(cc64srcs) \
 build-cc64.sh uf-build-base.T64
	./build-cc64.sh

c64files/cc64v05pe: $(cc64srcs) $(peddisrcs) \
 build-cc64pe.sh uf-build-base.T64
	./build-cc64pe.sh

c64files/peddi03: $(peddisrcs) \
 build-peddi.sh uf-build-base.T64
	./build-peddi.sh


# cc64 T64 tape images

cc64v05.T64: c64files/cc64v05

cc64v05pe.T64: c64files/cc64v05pe

peddi03.T64: c64files/peddi03


# Forth T64 tape images

devenv-uF83.T64: devenv-uF83

uf-build-base.T64: uf-build-base

uF83-382-c64.T64: uF83-382-c64


# Runtime module rules

rt-c64-0801.o rt-c64-0801.sym: rt-c64-0801.a
	acme -f cbm -l rt-c64-0801.sym -o rt-c64-0801.o rt-c64-0801.a

rt-c64-0801.h: rt-c64-0801.sym generate_pragma_cc64.awk
	awk -f generate_pragma_cc64.awk -F '$$' rt-c64-0801.sym >rt-c64-0801.h
	cat rt-c64-0801.h

rt-c64-0801.i:
	awk 'BEGIN{ printf("\x00\x90");}' > rt-c64-0801.i
	# An empty binary file with load (arbitrary) address $9000
	# Might be worth encoding in an asm source for clarity.


# Charset rules

c-charset: c-charset.a
	acme -f cbm -l c-charset.sym -o c-charset c-charset.a

c-char-rom-gen: c-char-rom-gen.a
	acme -f cbm -o c-char-rom-gen c-char-rom-gen.a

c-chargen: c-char-rom-gen
	x64 -virtualdev +truedrive -drive8type 1541 -fs8 . \
	-keybuf 'load"c-char-rom-gen",8\nrun\n'


# Generic T64 tape image rules

%.T64: %
	bin2t64 $< $@

%.T64: c64files/%
	bin2t64 $< $@


# Rules, mostly generic, to populate c64files/

c64files/%.fth: %.fth
	ascii2petscii $< $@
	touch -r $< $@

c64files/%.fth: src/*/%.fth
	ascii2petscii $< $@
	touch -r $< $@

c64files/%.c: %.c
	ascii2petscii $< $@
	touch -r $< $@

c64files/%.h: %.h
	ascii2petscii $< $@
	touch -r $< $@

c64files/%.i: %.i
	cp --preserve=timestamps $< $@

c64files/%.o: %.o
	cp --preserve=timestamps $< $@

c64files/c-charset: c-charset
	cp --preserve=timestamps $< $@

# Generic rules to update the .fth readable copies of the .d64 sources

src/%.fth: src/%.d64
		ufscr2file $< $@
