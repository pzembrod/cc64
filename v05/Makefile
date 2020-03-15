
all: baselib.o baselib.h helloworld.c kernal-io.c c-charset c-char-rom-gen

clean:
	rm -f baselib.o baselib.sym baselib.h baselib.h.4pet
	rm -f helloworld.c kernal-io.c
	rm -f c-charset c-char-rom-gen


baselib.o baselib.sym: baselib.a
	acme -f cbm -l baselib.sym -o baselib.o baselib.a

baselib.h.4pet: baselib.sym generate_pragma_cc64.awk
	awk -f generate_pragma_cc64.awk -F '$$' baselib.sym >baselib.h.4pet
	cat baselib.h.4pet

baselib.h: baselib.h.4pet

helloworld.c: helloworld.c.4pet

kernal-io.c: kernal-io.c.4pet

c-charset: c-charset.a
	acme -f cbm -l c-charset.sym -o c-charset c-charset.a

c-char-rom-gen: c-char-rom-gen.a
	acme -f cbm -o c-char-rom-gen c-char-rom-gen.a

%.c: %.c.4pet
	ascii2petscii $< $@

%.h: %.h.4pet
	ascii2petscii $< $@
