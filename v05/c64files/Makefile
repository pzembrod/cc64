
c_files = rt-c64-0801.h helloworld.c kernal-io.c
fth_files = build-cc64.fth build-cc64pe.fth build-peddi.fth
s00files = $(s00c_files) $(s00fth_files)
p00files = rt-c64-0801.o.P00 cc64v05.P00 cc64v05pe.P00 devenv-uF83.P00 peddi03.P00 uf-build-base.P00

c64files: $(c_files) $(fth_files)

%.c: ../%.c
	ascii2petscii $< $@

%.h: ../%.h
	ascii2petscii $< $@

%.fth: ../%.fth
	ascii2petscii $< $@
