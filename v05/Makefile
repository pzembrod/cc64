
p00files = baselib.o.P00 cc64v05.P00 devenv-uF83.P00
s00files = baselib.h.S00 helloworld.c.S00 kernal-io.c.S00

all: baselib.o $(p00files) $(s00files) c-charset c-char-rom-gen

clean:
	rm -f baselib.o baselib.sym baselib.h.S00 baselib.h
	rm -f helloworld.c.S00 kernal-io.c.S00
	rm -f c-charset c-char-rom-gen


cc64v05.P00: cc64v05

baselib.o baselib.sym: baselib.a
	acme -f cbm -l baselib.sym -o baselib.o baselib.a

baselib.o.P00: baselib.o

baselib.h: baselib.sym generate_pragma_cc64.awk
	awk -f generate_pragma_cc64.awk -F '$$' baselib.sym >baselib.h
	cat baselib.h

baselib.h.S00: baselib.h


helloworld.c.S00: helloworld.c

kernal-io.c.S00: kernal-io.c


c-charset: c-charset.a
	acme -f cbm -l c-charset.sym -o c-charset c-charset.a

c-char-rom-gen: c-char-rom-gen.a
	acme -f cbm -o c-char-rom-gen c-char-rom-gen.a


%.P00: %
	bin2p00 $< $@

%.c.S00: %.c
	txt2s00 $< $@

%.h.S00: %.h
	txt2s00 $< $@
