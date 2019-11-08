
test:app
	readelf -l app
	./app

app:main.o syscall.o
	ld -static -T linker_script.lds -e main -o app $^

main.o:main.c
	gcc -g -c -o $@ $<

syscall.o:syscall.S
	as -o $@ $<

