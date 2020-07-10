c7c: lex.yy.c y.tab.c c7c.c
	gcc -o c7c lex.yy.c y.tab.c c7c.c

lex.yy.c: c7.l
	flex c7.l

y.tab.c: c7.y
	bison -y -d c7.y

