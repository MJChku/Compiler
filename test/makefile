test: lex.yy.c y.tab.c
	gcc -o test lex.yy.c y.tab.c

lex.yy.c: tdp.l tdp.h
	flex tdp.l

y.tab.c: tdp.y  tdp.h
	bison -y -d tdp.y

