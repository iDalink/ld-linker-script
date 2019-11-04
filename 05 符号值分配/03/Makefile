.PHONY:test

test:app
	readelf -l app

app:app.o tool.o tool_base.o linker_script.lds
	ld -T linker_script.lds

app.o:app.c
	gcc -g -c -o $@ $<


tool.o:tool.c tool.h
	gcc -g -c -o $@ $<

tool_base.o:tool_base.S
	as -g -o $@ $<
