
test:test2
	echo Test success!

test2:main.o linker_script.lds
	ld -nostdlib -T linker_script.lds -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o app  -L/usr/lib/gcc/x86_64-linux-gnu/6/ -L /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/Scrt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/6/crtbeginS.o main.o -lgcc -lgcc_s -lc /usr/lib/gcc/x86_64-linux-gnu/6/crtendS.o /usr/lib/x86_64-linux-gnu/crtn.o
	readelf -l app
	./app

test1:main.o
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o app -L/usr/lib/gcc/x86_64-linux-gnu/6/ /usr/lib/x86_64-linux-gnu/Scrt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/6/crtbeginS.o main.o -lgcc -lgcc_s -lc /usr/lib/gcc/x86_64-linux-gnu/6/crtendS.o /usr/lib/x86_64-linux-gnu/crtn.o
	readelf -l app
	./app


main.o:main.c
	gcc -g -c -o $@ $<


