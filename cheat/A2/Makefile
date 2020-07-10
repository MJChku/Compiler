all: test

ABCparser.tab.c ABCparser.tab.h:	ABCparser.y a3.h
	bison -d ABCparser.y

lex.yy.c: ABCscanner.l ABCparser.tab.h a3.h
	flex ABCscanner.l

test: lex.yy.c ABCparser.tab.c ABCparser.tab.h a3.h
	gcc -o test ABCparser.tab.c lex.yy.c
