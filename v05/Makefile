
p00files = baselib.o.P00 cc64v05.P00 cc64v05pe.P00 devenv-uF83.P00 peddi02.P00 uf-build-base.P00
s00c_files = baselib.h.S00 helloworld.c.S00 kernal-io.c.S00
s00fth_files = build-cc64.fth.S00 build-cc64pe.fth.S00 build-peddi.fth.S00
s00files = $(s00c_files) $(s00fth_files)
t64files = cc64v05.T64 cc64v05pe.T64 devenv-uF83.T64 peddi02.T64 uf-build-base.T64
charsetfiles = c-charset c-char-rom-gen


all: baselib.o $(p00files) $(s00files) $(t64files) $(charsetfiles)

clean:
	rm -f baselib.o baselib.sym baselib.h.S00 baselib.h
	rm -f helloworld.c.S00 kernal-io.c.S00
	rm -f c-charset c-char-rom-gen


cc64v05.P00: cc64v05

cc64v05.T64: cc64v05

cc64v05pe.P00: cc64v05pe

cc64v05pe.T64: cc64v05pe

peddi02.P00: peddi02

peddi02.T64: peddi02

devenv-uF83.P00: devenv-uF83

devenv-uF83.T64: devenv-uF83

uf-build-base.P00: uf-build-base

uf-build-base.T64: uf-build-base


baselib.o baselib.sym: baselib.a
	acme -f cbm -l baselib.sym -o baselib.o baselib.a

baselib.o.P00: baselib.o

baselib.h: baselib.sym generate_pragma_cc64.awk
	awk -f generate_pragma_cc64.awk -F '$$' baselib.sym >baselib.h
	cat baselib.h

baselib.h.S00: baselib.h


helloworld.c.S00: helloworld.c

kernal-io.c.S00: kernal-io.c


build-cc64.fth.S00: build-cc64.fth


c-charset: c-charset.a
	acme -f cbm -l c-charset.sym -o c-charset c-charset.a

c-char-rom-gen: c-char-rom-gen.a
	acme -f cbm -o c-char-rom-gen c-char-rom-gen.a


%.P00: %
	bin2p00 $< $@

%.T64: %
	bin2t64 $< $@

%.c.S00: %.c
	txt2s00 $< $@

%.h.S00: %.h
	txt2s00 $< $@

%.fth.S00: %.fth
	txt2s00 $< $@
