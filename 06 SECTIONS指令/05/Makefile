.PHONY:test

test:app
	objcopy -O binary app app.bin
	ls -lh

app:app.o tool.o tool2.o tool_base.o linker_script.lds
	ld --gc-sections -T linker_script.lds

tool2.o:tool.o
	cp $< $@

app.o:app.c
	gcc -ffunction-sections -g -c -o $@ $<


tool.o:tool.c tool.h
	gcc -g -c -o $@ $<

tool_base.o:tool_base.S
	as -g -o $@ $<
