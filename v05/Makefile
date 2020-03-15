
all: baselib.o baselib.h helloworld.c kernal-io.c c-charset c-char-rom-gen

clean:
	rm -f baselib.o baselib.sym baselib.h.S00 baselib.h
	rm -f helloworld.c.S00 kernal-io.c.S00
	rm -f c-charset c-char-rom-gen


baselib.o baselib.sym: baselib.a
	acme -f cbm -l baselib.sym -o baselib.o baselib.a

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

%.c.S00: %.c
	txt2s00 $< $@

%.h.S00: %.h
	txt2s00 $< $@
