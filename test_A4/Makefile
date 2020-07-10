prog = fact rev-c recursive-fact max demo
sources = $(foreach p, $(prog), $p.sc)
compiled = $(foreach p, $(prog), $p.as)


c5c: lex.yy.c y.tab.c c5c.c
	gcc -g -o c5c lex.yy.c y.tab.c c5c.c

nas: nas.c nas.tab.c
	gcc -o nas nas.c nas.tab.c

nas.c: nas.l
	flex -o nas.c nas.l

nas.tab.c: nas.y
	bison -d nas.y    
    
lex.yy.c: c5.l
	flex c5.l

y.tab.c: c5.y
	bison -y -d c5.y

%.as: %.sc c5c
	./c5c $< 1> $@
    
.phony: cleanc5 cleannas cleanall makeall remake testall
cleanc5:
	$(RM) lex.yy.c y.tab.c y.tab.h c5c
    
cleannas:
	$(RM) nas.c nas.tab.c nas.tab.h nas

cleanprog:
	$(RM) $(compiled) 
    
cleanall:
	make cleanc5
	make cleannas
	make cleanprog
    
makeall:
	make c5c
	make nas

remake:
	make cleanall
	make makeall
    
    
testall: c5c nas $(compiled)
	