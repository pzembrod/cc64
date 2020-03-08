
all: baselib.o baselib.h helloworld.c kernal-io.c

clean:
	rm -f baselib.o baselib.sym baselib.h baselib.h.4pet
	rm -f helloworld.c kernal-io.c


baselib.o baselib.sym: baselib.a
	acme -f cbm -l baselib.sym -o baselib.o baselib.a

baselib.h.4pet: baselib.sym generate_pragma_cc64.awk
	awk -f generate_pragma_cc64.awk -F '$$' baselib.sym >baselib.h.4pet
	cat baselib.h.4pet

baselib.h: baselib.h.4pet

helloworld.c: helloworld.c.4pet

kernal-io.c: kernal-io.c.4pet

charset: charset.a
	acme -f cbm -l charset.sym -o charset charset.a

%.c: %.c.4pet
	ascii2petscii $< $@

%.h: %.h.4pet
	ascii2petscii $< $@
