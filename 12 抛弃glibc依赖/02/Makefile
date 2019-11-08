
test:app
	readelf -l app
	export LD_LIBRARY_PATH=.
	./app

app:main.o libantlibc.so linker_script.lds Makefile
	ld -T linker_script.lds -dynamic-linker /lib64/ld-linux-x86-64.so.2 -L. -e main -o app main.o -lantlibc

main.o:main.c
	gcc -g -c -o $@ $<

libantlibc.so:syscall.o
	ld -shared -o $@ $^
	readelf -l $@

syscall.o:syscall.S
	as -o $@ $<

