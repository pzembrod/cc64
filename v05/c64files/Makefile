
c_files = rt-c64-0801.h helloworld.c kernal-io.c

c64files: $(c_files)

%.c: ../%.c
	ascii2petscii $< $@

%.h: ../%.h
	ascii2petscii $< $@
