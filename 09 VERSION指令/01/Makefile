.PHONY:test

test:app
	export LD_LIBRARY_PATH=. && ./app

app:libtool.so app.o
	gcc -g -o $@ $^

app.o:app.c
	gcc -g -c -o $@ $<

libtool.so:tool.o tool_base.o
	ld --version-script=version_script.lds -shared -o $@ $^

tool.o:tool.c tool.h
	gcc -fPIC -g -c -o $@ $<

tool_base.o:tool_base.S
	as -g -o $@ $<

clean:
	rm *.o app libtool.so
