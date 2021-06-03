
# cc64 sources and binaries
commonsrcs_ascii = $(wildcard src/common/*.fth)
commonsrcs = $(patsubst src/common/%, %, $(commonsrcs_ascii))
cc64srcs_ascii = $(wildcard src/cc64/*.fth)
cc64srcs = $(patsubst src/cc64/%, %, $(cc64srcs_ascii))
peddisrcs_ascii = $(wildcard src/peddi/*.fth)
peddisrcs = $(patsubst src/peddi/%, %, $(peddisrcs_ascii))
cc64srcs_c64 = $(patsubst %, c64files/%, $(cc64srcs) $(commonsrcs))
cc64srcs_c16 = $(patsubst %, c16files/%, $(cc64srcs) $(commonsrcs))
cc64srcs_x16 = $(patsubst %, x16files/%, $(cc64srcs) $(commonsrcs))
peddisrcs_c64 = $(patsubst %, c64files/%, $(peddisrcs) $(commonsrcs))
peddisrcs_c16 = $(patsubst %, c16files/%, $(peddisrcs) $(commonsrcs))
cc64_binaries = cc64 cc64pe peddi
cc64_c64_t64_files = $(patsubst %, autostart-c64/%.T64, $(cc64_binaries))
cc64_c16_t64_files = $(patsubst %, autostart-c16/%.T64, $(cc64_binaries))

# runtime and sample files
rt_files = \
  rt-c64-0801.h rt-c64-0801.i rt-c64-0801.o \
  rt-c16-1001.h rt-c16-1001.i rt-c16-1001.o \
  rt-x16-0801.h rt-x16-0801.i rt-x16-0801.o \
  rt-c64-08-9f.h rt-c64-08-9f.i rt-c64-08-9f.o \
  rt-c16-10-7f.h rt-c16-10-7f.i rt-c16-10-7f.o \
  rt-x16-08-9e.h rt-x16-08-9e.i rt-x16-08-9e.o

sample_files = helloworld-c64.c helloworld-c16.c helloworld-x16.c \
  kernal-io-c64.c kernal-io-c16.c sieve-c64.c

# c64files content
c64dir_content = $(cc64_binaries) $(rt_files) $(sample_files) c-charset
c64dir_files = $(patsubst %, c64files/% , $(c64dir_content))

# c16files content
c16dir_content = $(cc64_binaries) $(rt_files) $(sample_files) c-charset
c16dir_files = $(patsubst %, c16files/% , $(c16dir_content))

# x16files content
x16dir_content = cc64 $(rt_files) $(sample_files) c-charset
x16dir_files = $(patsubst %, x16files/% , $(x16dir_content))

# PETSCII sources and VolksForth bases for manual recompile
recompile_dir = recompile-cc64
recompile_srcs = $(patsubst %, $(recompile_dir)/%, \
    $(cc64srcs) $(peddisrcs) $(commonsrcs))
recompile_forths = $(patsubst forth/%, $(recompile_dir)/%, \
    $(wildcard forth/v4th*))

# Forth binaries
forth_binaries = devenv-uF83
forth_t64_files = $(patsubst %, autostart-c64/%.T64, $(forth_binaries))


all: c64 c16 x16 etc

release: cc64-doc.zip \
  cc64-c64files.zip cc64-c64files.d64 \
  cc64-c16files.zip cc64-c16files.d64 \
  cc64-x16files.zip cc64-x16files-sdcard.zip \
  $(recompile_dir).zip
	rm -rf release
	mkdir release
	cp -p $^ release/


.SECONDARY:

c64: cc64-c64-t64 $(c64dir_files) cc64-c64files.zip cc64-c64files.d64

c16: cc64-c16-t64 $(c16dir_files) cc64-c16files.zip cc64-c16files.d64

x16: $(x16dir_files) cc64-x16files.zip cc64-x16files-sdcard.zip

cc64-c64-t64: $(cc64_c64_t64_files) autostart-c64/cc64prof.T64

cc64-c16-t64: $(cc64_c16_t64_files)

cc64-c64files.zip: $(c64dir_files) COPYING
	rm -f $@
	zip -r $@ $^

cc64-c16files.zip: $(c16dir_files) COPYING
	rm -f $@
	zip -r $@ $^

cc64-x16files.zip: $(x16dir_files) COPYING
	rm -f $@
	zip -r $@ $^

cc64-c64files.d64: $(c64dir_files) tmp/copying
	rm -f $@
	c1541 -format cc64-c64,cc d64 $@
	c1541 -attach $@ $(patsubst %, -write c64files/%, $(cc64_binaries))
	c1541 -attach $@ -write c64files/rt-c64-0801.h rt-c64-0801.h,s
	c1541 -attach $@ -write c64files/rt-c64-0801.i
	c1541 -attach $@ -write c64files/rt-c64-0801.o
	c1541 -attach $@ -write c64files/rt-c16-1001.h rt-c16-1001.h,s
	c1541 -attach $@ -write c64files/rt-c16-1001.i
	c1541 -attach $@ -write c64files/rt-c16-1001.o
	c1541 -attach $@ -write c64files/rt-x16-0801.h rt-x16-0801.h,s
	c1541 -attach $@ -write c64files/rt-x16-0801.i
	c1541 -attach $@ -write c64files/rt-x16-0801.o
	c1541 -attach $@ -write c64files/c-charset
	c1541 -attach $@ -write c64files/helloworld-c64.c helloworld-c64.c,s
	c1541 -attach $@ -write c64files/kernal-io-c64.c kernal-io-c64.c,s
	c1541 -attach $@ -write c64files/helloworld-c16.c helloworld-c16.c,s
	c1541 -attach $@ -write c64files/kernal-io-c16.c kernal-io-c16.c,s
	c1541 -attach $@ -write tmp/copying

cc64-c16files.d64: $(c16dir_files) tmp/copying
	rm -f $@
	c1541 -format cc64-c16,cc d64 $@
	c1541 -attach $@ $(patsubst %, -write c16files/%, $(cc64_binaries))
	c1541 -attach $@ -write c16files/rt-c64-0801.h rt-c64-0801.h,s
	c1541 -attach $@ -write c16files/rt-c64-0801.i
	c1541 -attach $@ -write c16files/rt-c64-0801.o
	c1541 -attach $@ -write c16files/rt-c16-1001.h rt-c16-1001.h,s
	c1541 -attach $@ -write c16files/rt-c16-1001.i
	c1541 -attach $@ -write c16files/rt-c16-1001.o
	c1541 -attach $@ -write c16files/rt-x16-0801.h rt-x16-0801.h,s
	c1541 -attach $@ -write c16files/rt-x16-0801.i
	c1541 -attach $@ -write c16files/rt-x16-0801.o
	c1541 -attach $@ -write c16files/c-charset
	c1541 -attach $@ -write c16files/helloworld-c64.c helloworld-c64.c,s
	c1541 -attach $@ -write c16files/kernal-io-c64.c kernal-io-c64.c,s
	c1541 -attach $@ -write c16files/helloworld-c16.c helloworld-c16.c,s
	c1541 -attach $@ -write c16files/kernal-io-c16.c kernal-io-c16.c,s
	c1541 -attach $@ -write tmp/copying

cc64-x16files-sdcard.zip: $(x16dir_files) emulator/copy-to-sd-img.sh \
  emulator/mk-sdcard.sh emulator/sdcard.sfdisk tmp/copying
	rm -f x16files.img $@
	emulator/mk-sdcard.sh emulator/sdcard.sfdisk x16files.img
	mformat -i x16files.img -F
	emulator/copy-to-sd-img.sh x16files.img $(x16dir_files)
	mcopy -i x16files.img tmp/copying ::COPYING
	zip $@ x16files.img

tmp/copying: COPYING
	test -d tmp || mkdir tmp
	ascii2petscii $< $@

cc64-doc.zip: $(wildcard *.md) COPYING
	zip $@ $^

etc: $(forth_t64_files) emulator/c-char-rom-gen

# The following utility build rule is based on my current setup of
# where VICE and x16emu have their default ROMs.
c-char-roms:
	patch-c-charset ~/.config/vice/C64/chargen \
	    emulator/c64-c-chargen -n 2048 -i 3072
	patch-c-charset ~/.config/vice/PLUS4/kernal \
	    emulator/c16-c-kernal -n 5120
	patch-c-charset ~/bin/rom.bin \
	    emulator/x16-c-rom.bin -n 99328


# PETSCII sources and VolksForth bases for manual recompile

recompile_dir = recompile-cc64
recompile_srcs = $(patsubst %, $(recompile_dir)/%, \
    $(cc64srcs) $(peddisrcs) $(commonsrcs))
recompile_forths = $(patsubst forth/%, $(recompile_dir)/%, \
    $(wildcard forth/v4th*))

$(recompile_dir).zip: COPYING recompile-readme \
  $(recompile_dir)/0readme $(recompile_srcs) $(recompile_forths)
	rm -f $@
	zip -r $@ $^

$(recompile_dir)/%.fth: src/*/%.fth
	test -d $(recompile_dir) || mkdir $(recompile_dir)
	ascii2petscii $< $@

$(recompile_dir)/%: forth/%
	test -d $(recompile_dir) || mkdir $(recompile_dir)
	cp $< $@

recompile-readme: doc/recompile-readme
	cp $< $@

$(recompile_dir)/0readme: doc/recompile-readme
	test -d $(recompile_dir) || mkdir $(recompile_dir)
	ascii2petscii $< $@


clean:
	rm -f c64files/*.fth c16files/*.fth x16files/*.fth
	rm -f c64files/*.log c16files/*.log x16files/*.log
	rm -f x16files.img recompile-readme
	rm -f [cx][16][64]files/notdone cc64-doc.zip
	rm -rf release tmp/*
	rm -rf $(recompile_dir) $(recompile_dir).zip
	$(MAKE) -C emulator clean
	$(MAKE) -C tests/e2e clean
	$(MAKE) -C tests/integration clean
	$(MAKE) -C tests/lib clean
	$(MAKE) -C tests/peddi clean
	$(MAKE) -C tests/unit clean

veryclean: clean
	rm -f c64files/*
	rm -f c64files.d64 c64files.zip
	rm -f c16files/*
	rm -f c16files.d64 c16files.zip
	rm -f x16files/*
	rm -f x16files.zip
	rm -f emulator/c-char-rom-gen
	rm -f autostart-c64/*.T64 autostart-c16/*.T64
	rm -f runtime/*

# Convenience rule for interactive debugging/developing:
# Provide all Forth sources in c64files/ in PETSCII format.
petscii64: $(cc64srcs_c64) $(peddisrcs_c64)


test64: autostart-c64/cc64.T64
	$(MAKE) -C tests/unit tests
	$(MAKE) -C tests/e2e fasttests64
	$(MAKE) -C tests/integration tests

alltests: sut
	$(MAKE) -C tests/e2e alltests
	$(MAKE) -C tests/unit tests
	$(MAKE) -C tests/integration tests
	$(MAKE) -C tests/peddi tests

fasttests: sut
	$(MAKE) -C tests/e2e fasttests
	$(MAKE) -C tests/unit tests
	$(MAKE) -C tests/integration tests
	$(MAKE) -C tests/peddi tests

slowtests: sut
	$(MAKE) -C tests/e2e slowtests
	$(MAKE) -C tests/unit tests
	$(MAKE) -C tests/integration tests
	$(MAKE) -C tests/peddi tests

sut: autostart-c64/cc64.T64 autostart-c16/cc64.T64 x16files/cc64 \
  autostart-c64/cc64pe.T64 autostart-c16/cc64pe.T64 \
  autostart-c64/peddi.T64 autostart-c16/peddi.T64 \
  autostart-c64/cc64prof.T64

# cc64 build rules

%files/cc64: $(cc64srcs_c64) $(cc64srcs_c16) \
 emulator/build-binary.sh emulator/run-in-vice.sh \
 autostart-%/vf-build-base.T64
	emulator/build-binary.sh $* cc64

%files/cc64pe: \
 $(cc64srcs_c64) $(cc64srcs_c16) \
 $(peddisrcs_c64) $(peddisrcs_c16) \
 emulator/build-binary.sh emulator/run-in-vice.sh \
 autostart-%/vf-build-base.T64
	emulator/build-binary.sh $* cc64pe

%files/peddi: $(peddisrcs_c64) $(peddisrcs_c16) \
 emulator/build-binary.sh emulator/run-in-vice.sh \
 autostart-%/vf-build-base.T64
	emulator/build-binary.sh $* peddi


x16files/cc64: $(cc64srcs_x16) \
 emulator/build-binary.sh emulator/run-in-x16emu.sh \
 x16files/vf-build-base
	emulator/build-binary.sh x16 cc64


c64files/cc64prof: $(cc64srcs_c64) \
 emulator/build-binary.sh emulator/run-in-vice.sh \
 autostart-c64/vf-build-base.T64
	emulator/build-binary.sh c64 cc64prof


# build base rule

c64files/vf-build-base: forth/v4th-c64
	cp $< $@

c16files/vf-build-base: forth/v4th-c16+
	cp $< $@

x16files/vf-build-base: forth/v4th-x16
	cp $< $@

$(recompile_dir)/%: forth/%
	cp $< $@


# Runtime module rules

runtime/rt-%.o runtime/rt-%.h: \
    src/runtime/rt-%.a src/runtime/generate_pragma_cc64.awk
	test -d tmp || mkdir tmp
	acme -f cbm -l tmp/rt-$*.sym -o runtime/rt-$*.o \
	  -I src/runtime src/runtime/rt-$*.a
	awk -f src/runtime/generate_pragma_cc64.awk -F '$$' \
	  tmp/rt-$*.sym > runtime/rt-$*.h

runtime/rt-%.i:
	awk 'BEGIN{ printf("\x00\x90");}' > $@
	# An empty binary file with (arbitrary) load address $9000
	# Might be worth encoding in an asm source for clarity.

c64files/%: runtime/%
	emulator/copy-to-emu.sh $< $@

c16files/%: runtime/%
	emulator/copy-to-emu.sh $< $@

x16files/%: runtime/%
	emulator/copy-to-emu.sh $< $@


# Charset rules

c64files/c-charset: src/runtime/c-charset-c64.a
	test -d tmp || mkdir tmp
	acme -f cbm -l tmp/c-charset-c64.sym -o $@ $<

c16files/c-charset: src/runtime/c-charset-c16.a
	test -d tmp || mkdir tmp
	acme -f cbm -l tmp/c-charset-c16.sym -o $@ $<

x16files/c-charset: src/runtime/c-charset-x16.a
	test -d tmp || mkdir tmp
	acme -f cbm -l tmp/c-charset-x16.sym -o $@ $<

emulator/c-char-rom-gen: src/runtime/c-char-rom-gen.a
	acme -f cbm -o $@ $<

emulator/c-chargen: emulator/c-char-rom-gen
	x64 -virtualdev +truedrive -drive8type 1541 -fs8 emulator \
	-keybuf 'load"c-char-rom-gen",8\nrun\n'


# Generic T64 tape image rules

autostart-c64/%.T64: c64files/%
	bin2t64 $< $@

autostart-c64/%.T64: forth/%
	bin2t64 $< $@

autostart-c16/%.T64: c16files/%
	bin2t64 $< $@

autostart-c16/%.T64: forth/%
	bin2t64 $< $@

autostart-x16/%.T64: x16files/%
	bin2t64 $< $@


# Generic rules to populate c64files/, c16files/, x16files/

c64files/%.fth: src/*/%.fth
	ascii2petscii $< $@
	touch -r $< $@

c64files/%.c: src/*/%.c
	ascii2petscii $< $@
	touch -r $< $@

c16files/%.fth: src/*/%.fth
	ascii2petscii $< $@
	touch -r $< $@

c16files/%.c: src/*/%.c
	ascii2petscii $< $@
	touch -r $< $@

x16files/%.fth: src/*/%.fth
	ascii2petscii $< $@
	touch -r $< $@

x16files/%.c: src/*/%.c
	ascii2petscii $< $@
	touch -r $< $@
