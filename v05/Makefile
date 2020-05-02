
cc64t64files = cc64v05.T64 cc64v05pe.T64 peddi03.T64
etct64files = devenv-uF83.T64 uf-build-base.T64
charsetfiles = c-charset c-char-rom-gen
subdirs = c64files-dir cc64-srcs
cc64srcs = src/cc64src1.d64 src/cc64src2.d64
peddisrc = src/peddi_src.d64


cc64: $(cc64t64files)

etc: rt-c64-0801.o rt-c64-0801.h \
 $(etct64files) $(charsetfiles) $(subdirs)

clean:
	rm -f rt-c64-0801.sym c-charset.sym

veryclean: clean
	rm -f rt-c64-0801.o rt-c64-0801.sym rt-c64-0801.h
	rm -f c-charset c-char-rom-gen
	rm -f c64files/cc64v05 c64files/cc64v05pe c64files/peddi03
	rm -f cc64v05.T64 cc64v05pe.T64 peddi03.T64

c64files-dir:
	$(MAKE) -C c64files

cc64-srcs:
	$(MAKE) -C src


c64files/cc64v05: $(cc64srcs) c64files/build-cc64.fth \
 build-cc64.sh uf-build-base.T64
	./build-cc64.sh

c64files/cc64v05pe: $(cc64srcs) $(peddisrc) c64files/build-cc64pe.fth \
 build-cc64pe.sh uf-build-base.T64
	./build-cc64pe.sh

c64files/peddi03: $(peddisrc) c64files/build-peddi.fth \
 build-peddi.sh uf-build-base.T64
	./build-peddi.sh


cc64v05.T64: c64files/cc64v05

cc64v05pe.T64: c64files/cc64v05pe

peddi03.T64: c64files/peddi03

devenv-uF83.T64: devenv-uF83

uf-build-base.T64: uf-build-base

uF83-382-c64.T64: uF83-382-c64


rt-c64-0801.o rt-c64-0801.sym: rt-c64-0801.a
	acme -f cbm -l rt-c64-0801.sym -o rt-c64-0801.o rt-c64-0801.a

rt-c64-0801.h: rt-c64-0801.sym generate_pragma_cc64.awk
	awk -f generate_pragma_cc64.awk -F '$$' rt-c64-0801.sym >rt-c64-0801.h
	cat rt-c64-0801.h


c-charset: c-charset.a
	acme -f cbm -l c-charset.sym -o c-charset c-charset.a

c-char-rom-gen: c-char-rom-gen.a
	acme -f cbm -o c-char-rom-gen c-char-rom-gen.a

c-chargen: c-char-rom-gen
	x64 -virtualdev +truedrive -drive8type 1541 -fs8 . \
	-keybuf 'load"c-char-rom-gen",8\nrun\n'

%.T64: c64files/%
	bin2t64 $< $@

%.T64: %
	bin2t64 $< $@

c64files/%.fth: %.fth
	ascii2petscii $< $@
