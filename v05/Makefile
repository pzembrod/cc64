
p00files = rt-c64-0801.o.P00 cc64v05.P00 cc64v05pe.P00 devenv-uF83.P00 peddi03.P00 uf-build-base.P00
s00c_files = rt-c64-0801.h.S00 helloworld.c.S00 kernal-io.c.S00
s00fth_files = build-cc64.fth.S00 build-cc64pe.fth.S00 build-peddi.fth.S00
s00files = $(s00c_files) $(s00fth_files)
t64files = cc64v05.T64 cc64v05pe.T64 devenv-uF83.T64 peddi03.T64 uf-build-base.T64
charsetfiles = c-charset c-char-rom-gen


all: rt-c64-0801.o $(p00files) $(s00files) $(t64files) $(charsetfiles)

clean:
	rm -f rt-c64-0801.o rt-c64-0801.sym rt-c64-0801.h.S00 rt-c64-0801.h
	rm -f helloworld.c.S00 kernal-io.c.S00
	rm -f c-charset c-char-rom-gen


cc64v05.P00: cc64v05

cc64v05.T64: cc64v05

cc64v05pe.P00: cc64v05pe

cc64v05pe.T64: cc64v05pe

peddi03.P00: peddi03

peddi03.T64: peddi03

devenv-uF83.P00: devenv-uF83

devenv-uF83.T64: devenv-uF83

uf-build-base.P00: uf-build-base

uf-build-base.T64: uf-build-base


rt-c64-0801.o rt-c64-0801.sym: rt-c64-0801.a
	acme -f cbm -l rt-c64-0801.sym -o rt-c64-0801.o rt-c64-0801.a

rt-c64-0801.i.P00: rt-c64-0801.i

rt-c64-0801.o.P00: rt-c64-0801.o

rt-c64-0801.h: rt-c64-0801.sym generate_pragma_cc64.awk
	awk -f generate_pragma_cc64.awk -F '$$' rt-c64-0801.sym >rt-c64-0801.h
	cat rt-c64-0801.h

rt-c64-0801.h.S00: rt-c64-0801.h


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
