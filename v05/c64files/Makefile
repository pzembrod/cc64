
c_files = rt-c64-0801.h helloworld.c kernal-io.c
o_files = rt-c64-0801.i rt-c64-0801.o

c64files: $(c_files) $(o_files)

%.c: ../%.c
	ascii2petscii $< $@

%.h: ../%.h
	ascii2petscii $< $@

%.i: ../%.i
	cp $< $@

%.o: ../%.o
	cp $< $@
