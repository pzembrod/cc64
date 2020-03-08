
all: baselib.o baselib.h

clean:
	rm baselib.o baselib.sym baselib.h


baselib.o baselib.sym: baselib.a
	acme -l baselib.sym -o baselib.o baselib.a

baselib.h: baselib.sym generate_pragma_cc64.awk
	awk -f generate_pragma_cc64.awk -F '$$' baselib.sym >baselib.h
	cat baselib.h
