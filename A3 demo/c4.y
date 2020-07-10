%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "calc3.h"
#include "supply.h"


/* prototypes */
nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *con(int value);
nodeType *con(char* value);
void freeNode(nodeType *p);
int ex(nodeType *p);
int yylex(void);

void yyerror(char *s);
function* funcstore[100];
int size = 0;                    /* symbol table */
%}

%union {
    hybrid* vandt;
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
%token FOR WHILE IF PRINT READ
%nonassoc IFX
%nonassoc ELSE

%left AND OR

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/' '%'
%nonassoc UMINUS

%type <vandt> intermediateValue
%type <nPtr> stmt expr stmt_list
%type <param> param param_list
%%

program:
        function                { exit(0); }
        ;

function:
          function stmt         { exe($2); freeNode($2); }
        ;
proc:
        VARIABLE param stmt  { funcstore[size++] = storefunc($1,$2,$3); }
	;
param:
	VARIABLE	{$$ = newlist($1);}
	|'(' param_list ')' {$$ = $2;}
	;
param_list:
	param               {$$ = $1;}
	| param_list ',' param {$$ = conclist($1,$3);}
	; 
stmt:
          ';'                            { $$ = opr(';', 2, NULL, NULL); }
        | expr ';'                       { $$ = $1; }
        | PRINT expr ';'                 { $$ = opr(PRINT, 1, $2); }
	|GETI '(' VARIABLE ')' ';'	 { $$ = opr(GETI, 1, $3); }
	|GETC '(' VARIABLE ')' ';'	{ $$ = opr(GETC, 1, $3); }
	|GETS '(' VARIABLE ')' ';'	{ $$ = opr(GETS, 1, $3); }
	|PUTI '(' expr ')' ';'		{ $$ = opr(PUTI, 1, $3); }
	|PUTC '(' expr ')' ';'		{ $$ = opr(PUTC, 1, $3); }
	|PUTS '(' expr ')' ';'		{ $$ = opr(PUTS, 1, $3); }
        |PUTI_ '(' expr ')' ';'		{ $$ = opr(PUTI_, 1, $3); }
	|PUTC_ '(' expr ')' ';'		{ $$ = opr(PUTC_, 1, $3); }
	|PUTS_ '(' expr ')' ';'		{ $$ = opr(PUTS_, 1, $3); }
//| READ VARIABLE ';'		 { $$ = opr(READ, 1, id($2)); }
        | VARIABLE '=' expr ';'          { $$ = opr('=', 2, id($1), $3); }
	| FOR '(' stmt stmt stmt ')' stmt { $$ = opr(FOR, 4, $3, $4,
$5, $7); }
        | WHILE '(' expr ')' stmt        { $$ = opr(WHILE, 2, $3, $5); }
        | IF '(' expr ')' stmt %prec IFX { $$ = opr(IF, 2, $3, $5); }
        | IF '(' expr ')' stmt ELSE stmt { $$ = opr(IF, 3, $3, $5, $7); }
        | '{' stmt_list '}'              { $$ = $2; }   
	| RETURN expr ';' 		 { $$ = opr(RETURN, 1, $2)}    
	;

stmt_list:
          stmt                  { $$ = $1; }
        | stmt_list stmt        { $$ = opr(';', 2, $1, $2); }
        ;

expr:
	  CHAR		 	{$$ = con($1);}
	| STRING 		{$$ = con($1);}         
	| INTEGER               { $$ = con($1); }
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
	| VARIABLE '(' param ')'{ $$ = opr(FUNC,1,findfunc($1,$3);}
        ;

%%

#define SIZEOF_NODETYPE ((char *)&p->con - (char *)p)


nodeType *findFunc(char* name, paramlist* arg){
	for (int i=0;i<size;i++){
	  if(strcmp(funcstore[i]->func.name,name)==0){
                nodeType *p = malloc(SIZEOF_NODETYPE+sizeof(function));
	        p->type = typeFunc;
		p->funcNode.func = funcstore[i];		
		p->funcNode.init = arg;
		return p;
	  } 
        }
        return NULL;
}

function *storefunc(char* name,paramlist* param, nodeType* stmt){
    function *p;
    size_t nodeSize;
    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(function)+sizeof(paramlist);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->name = name
    p->stmt = stmt;
    p->localval = param
    return p;
}


nodeType *con(int value) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(conNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon;
    p->con.value = value;

    return p;
}


nodeType *con(char* value) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(conNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon;
    p->con.cValue = value;

    return p;
}


nodeType *id(int i) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(idNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    p->id.i = i;

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
    yyparse();
    return 0;
}
