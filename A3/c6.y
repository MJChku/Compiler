%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "c6.h"
#define YYDEBUG 0


/* prototypes */
void layoutf(function* func, int seq);
nodeType *useFunc(char* name, paramlist* arg);
void storefunc(char* name,paramlist* param, nodeType* stmt);
nodeType *opr(int oper, int nops, ...);
nodeType *id(char* name);
nodeType *coni(int value);
nodeType *conc(char* value);
void freeNode(nodeType *p);
void exe(nodeType *p);
paramlist *newlist(nodeType* b);
paramlist *conclist(paramlist* a, nodeType* b);
int yylex(void);
void yyerror(char *s);
function* funcstore[100];
int size = 0;                    /* symbol table */
%}

%union {
    char* sValue;
    char* cValue;		/*character(s) value*/
    int iValue;                 /* integer value */
    char* sIndex;               
    nodeType *nPtr;             /* node pointer */
    paramlist *param;
};

%token <sValue> STRING
%token <cValue> CHAR
%token <iValue> INTEGER
%token <sIndex> VARIABLE
%token FOR WHILE IF GETI GETC GETS PUTI PUTS PUTC PUTI_ PUTS_ PUTC_ RETURN
%nonassoc IFX
%nonassoc ELSE

%left AND OR

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/' '%'
%nonassoc UMINUS

%type <nPtr> program
%type <nPtr> stmt expr stmt_list 
%type <param> param_list
%%

program: //null
         stmt_list   { 
		exe($1); 
		for(int i=0; i < size;i++){
		    layoutf(funcstore[i],i);	
		} 
		freeNode($1);exit(0); }
        ;

//function:
  //      function stmt         {$$ = opr(';', 2, $1, $2); }//freeNode($2); }
	//| // Null        
	//;

stmt_list:
          stmt                  { $$ = $1; }
        | stmt_list stmt        { $$ = opr(';', 2, $1, $2); }
        ;

param_list: { $$ = newlist(NULL); }
	| expr {$$ = newlist($1);}
	| param_list ',' expr {$$ = conclist($1,$3);}
	;
stmt:
          ';'                            { $$ = opr(';', 2, NULL, NULL); }
        | expr ';'                       { $$ = $1; }
       // | PRINT expr ';'                 { $$ = opr(PRINT, 1, $2); }
	| GETI '(' VARIABLE ')' ';'	 { $$ = opr(GETI, 1, id($3)); }
	| GETC '(' VARIABLE ')' ';'	{ $$ = opr(GETC, 1, id($3)); }
	| GETS '(' VARIABLE ')' ';'	{ $$ = opr(GETS, 1, id($3)); }
	| PUTI '(' expr ')' ';'		{ $$ = opr(PUTI, 1, $3); }
	| PUTC '(' expr ')' ';'		{ $$ = opr(PUTC, 1, $3); }
	| PUTS '(' expr ')' ';'		{ $$ = opr(PUTS, 1, $3); }
        | PUTI_ '(' expr ')' ';'		{ $$ = opr(PUTI_, 1, $3); }
	| PUTC_ '(' expr ')' ';'		{ $$ = opr(PUTC_, 1, $3); }
	| PUTS_ '(' expr ')' ';'		{ $$ = opr(PUTS_, 1, $3); }
//| READ VARIABLE ';'		 { $$ = opr(READ, 1, id($2)); }
        | VARIABLE '=' expr ';'          { $$ = opr('=', 2, id($1), $3); }
	| FOR '(' stmt stmt stmt ')' stmt { $$ = opr(FOR, 4, $3, $4,
$5, $7); }
        | WHILE '(' expr ')' stmt        { $$ = opr(WHILE, 2, $3, $5); }
        | IF '(' expr ')' stmt %prec IFX { $$ = opr(IF, 2, $3, $5); }
        | IF '(' expr ')' stmt ELSE stmt { $$ = opr(IF, 3, $3, $5, $7); }
        | '{' stmt_list '}'              { $$ = $2; } 
	| RETURN ';' 		 { $$ = opr(RETURN, 0);}     
	| RETURN expr ';' 		 { $$ = opr(RETURN, 1, $2);}    
	| VARIABLE '(' param_list ')' '{' { storefunc($1,$3, NULL);} stmt_list '}'  {$$ = opr(';', 2, NULL, NULL);  storefunc($1,$3,$7); }
	;

expr:
	  CHAR		 	{$$ = conc($1);}
	| STRING 		{$$ = conc($1);}         
	| INTEGER               { $$ = coni($1); }
        | VARIABLE              { $$ = id($1); }
        | '-' expr %prec UMINUS { $$ = opr(UMINUS, 1, $2); }
        | expr '+' expr         { $$ = opr('+', 2, $1, $3); }
        | expr '-' expr         { $$ = opr('-', 2, $1, $3); }
        | expr '*' expr         { $$ = opr('*', 2, $1, $3); }
        | expr '%' expr         { $$ = opr('%', 2, $1, $3); }
        | expr '/' expr         { $$ = opr('/', 2, $1, $3); }
        | expr '<' expr         { $$ = opr('<', 2, $1, $3); }
        | expr '>' expr         { $$ = opr('>', 2, $1, $3); }
        | expr GE expr          { $$ = opr(GE, 2, $1, $3); }
        | expr LE expr          { $$ = opr(LE, 2, $1, $3); }
        | expr NE expr          { $$ = opr(NE, 2, $1, $3); }
        | expr EQ expr          { $$ = opr(EQ, 2, $1, $3); }
	| expr AND expr		{ $$ = opr(AND, 2, $1, $3); }
	| expr OR expr		{ $$ = opr(OR, 2, $1, $3); }
        | '(' expr ')'          { $$ = $2; }
	| VARIABLE '(' param_list ')' { $$ = useFunc($1,$3);}
        ;

%%

#define SIZEOF_NODETYPE ((char *)&p->con - (char *)p)


nodeType *useFunc(char* name, paramlist* arg){
	int pos = -1;        
	for (int i=0;i<size;i++){
	  if(strcmp(funcstore[i]->name,name)==0)
      		pos = i; 
        } 
	nodeType *p = (nodeType* ) malloc(sizeof(nodeType)+sizeof(paramlist));
        p->type = typeFunc;
	p->funcNode.name =(char*) malloc(sizeof(char)*12);
	sprintf(p->funcNode.name,"%s",name);
	p->funcNode.pos = pos;
	p->funcNode.init = arg;
	return p;
}


void storefunc(char* name,paramlist* param, nodeType* stmt){
    
    function *pf;
    size_t nodeSize;
    /* allocate node */
    nodeSize = sizeof(function)+sizeof(paramlist);
    if ((pf = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    sprintf(pf->name,"%s", name);
    pf->stmt = stmt;
    pf->localval = param;
    for (int i =0;i<size;i++){
	if(strcmp(funcstore[i]->name,name) == 0){
		funcstore[i] = pf; return;	
	}
    }
    funcstore[size++] = pf;
}



nodeType *coni(int value) {
    nodeType *p;
    size_t nodeSize;
    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(conNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon;
    p->con.value = value;
    p->con.type = INT;

    return p;
}


nodeType *conc(char* value) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(conNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon;
    p->con.cValue = (char*) malloc(sizeof(char)*strlen(value));
    strcpy(p->con.cValue, value);
    if(strlen(value) == 1){
	p->con.type = CHARC;   
    }else p->con.type =STR;

    return p;
}


nodeType *id(char* name) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(idNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    sprintf(p->id.name,"%s",name);

    return p;
}

//=', 2, id($1), $3); }

nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    size_t nodeSize;
    int i;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(oprNodeType) +
        (nops - 1) * sizeof(nodeType*);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}



paramlist *newlist(nodeType* b ){
   paramlist* newone;
   newone = malloc(sizeof(paramlist));
   newone->size = 0;     
   if(b!=NULL)
   	newone->name[newone->size++] = b;   
   return newone;
}

paramlist *conclist(paramlist* a, nodeType* b ){
   a->name[a->size++] = b; 
   return a;
}
void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOpr) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
    }
    free (p);
}

void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}

int main(int argc, char **argv) {
    extern FILE* yyin;
    yyin = fopen(argv[1], "r");
    #if YYDEBUG
        yydebug = 1;
    #endif
    yyparse();
    return 0;
}
