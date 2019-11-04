.PHONY:test

test:app
	./app

app:app.o tool.o tool_base.o
	gcc -g -o $@ $^


app.o:app.c
	gcc -g -c -o $@ $<


tool.o:tool.c tool.h
	gcc -g -c -o $@ $<

tool_base.o:tool_base.S
	as -g -o $@ $<
