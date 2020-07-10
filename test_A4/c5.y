%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "calc3.h"
#define YYDEBUG 0


/* prototypes */
nodeType *opr(int oper, int nops, ...);
nodeType *id(char *i);
nodeType *con(int value);
nodeType *con_c(char value);
nodeType *con_s(char *value);
nodeType *exprs(int noexpr, nodeType *old, nodeType *new);
nodeType *func(char *name, nodeType *arg, nodeType *body);
nodeType *call(char *name, nodeType *arg);
nodeType *scope(nodeType *stmt);
nodeType *arrayId(char *i,arraydim *dim);
nodeType *arrayDec(char *i,arraydec *dim);

void freeNode(nodeType *p);
int ex(nodeType *p, context *cont);

int yylex(void);

void yyerror(char *s);

%}

%union {
    arraydim* dimension;
    arraydec* decDimension;
    char cValue;                /* char value */
    char *sValue;               /* string address */
    int iValue;                 /* integer value */
    char *sIndex;               /* variable name string address */
    nodeType *nPtr;             /* node pointer */
};


%token <cValue> CHARACTER
%token <sValue> STRING 
%token <iValue> INTEGER
%token <sIndex> VARIABLE
%token FOR WHILE IF PUTI PUTC PUTS PUTI_ PUTC_ PUTS_ GETI GETC GETS RETURN DISCARD ARRAY
%nonassoc IFX
%nonassoc ELSE

%left AND OR

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/' '%'
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list expr_list
%type <dimension> array_dmt
%type <decDimension> array_dec
%%

program:
        function                { free(global->vars);
                                  free(global->funcs);
                                  exit(0); }
        ;

function:
          stmt_list      { ex($1, global); freeNode($1); }
        | %empty /* NULL */
        ;

stmt:
          ';'                                   { $$ = opr(';', 2, NULL, NULL); }
        | RETURN expr ';'                       { $$ = opr(RETURN, 1, $2); }
        | expr ';'                              { $$ = $1;}//opr(DISCARD, 1, $1); }
        | PUTI '(' expr ')' ';'                 { $$ = opr(PUTI, 1, $3); }
        | PUTC '(' expr ')' ';'                 { $$ = opr(PUTC, 1, $3); }
        | PUTS '(' expr ')' ';'                 { $$ = opr(PUTS, 1, $3); }
        | PUTI_ '(' expr ')' ';'                { $$ = opr(PUTI_, 1, $3); }
        | PUTC_ '(' expr ')' ';'                { $$ = opr(PUTC_, 1, $3); }
        | PUTS_ '(' expr ')' ';'                { $$ = opr(PUTS_, 1, $3); }
        | GETI '(' VARIABLE ')' ';'		        { $$ = opr(GETI, 1, id($3)); }
        | GETC '(' VARIABLE ')' ';'		        { $$ = opr(GETC, 1, id($3)); }
        | GETS '(' VARIABLE ')' ';'		        { $$ = opr(GETS, 1, id($3)); }
        | VARIABLE '=' expr ';'                 { $$ = opr('=', 2, id($1), $3); }
	| VARIABLE array_dmt '=' expr ';'       { $$ = opr('=', 2, arrayId($1,$2), $4); }
	| ARRAY VARIABLE array_dec '=' expr ';' { $$ = opr('=', 2, arrayDec($2,$3), $5); }
        | FOR '(' stmt stmt stmt ')' stmt       { $$ = opr(FOR, 4, $3, $4, $5, $7); }
        | WHILE '(' expr ')' stmt               { $$ = opr(WHILE, 2, $3, $5); }
        | IF '(' expr ')' stmt %prec IFX        { $$ = opr(IF, 2, $3, $5); }
        | IF '(' expr ')' stmt ELSE stmt        { $$ = opr(IF, 3, $3, $5, $7); }
        | '{' stmt_list '}'                     { $$ = scope($2); }
        | '{' '}'                               { $$ = scope(opr(';', 2, NULL, NULL)); }
        | VARIABLE '(' expr_list ')' '{' stmt_list '}'    { $$ = func($1, $3, $6); } //function declaration
        | VARIABLE '(' expr_list ')' '{' '}'    { $$ = func($1, $3, opr(';', 2, NULL, NULL)); } //function declaration
        ;

stmt_list:
          stmt                  { $$ = $1; }
        | stmt_list stmt        { $$ = opr(';', 2, $1, $2); }
        ;

array_dmt:
          '[' expr ']'         { arraydim* newd = malloc(sizeof(arraydim)); newd->size = 0; newd->dim[newd->size++] = $2; $$ = newd; }
	| array_dmt '[' expr']' {$1->dim[$1->size++] = $3; $$ = $1; }
	;

array_dec:
          '[' INTEGER ']'         { arraydec* newd = malloc(sizeof(arraydec)); newd->size = 0; newd->dim[newd->size++] = $2; $$ = newd; }
	| array_dec '[' INTEGER']' {$1->dim[$1->size++] = $3; $$ = $1; }
	;

expr:
          INTEGER               { $$ = con($1); }
        | CHARACTER             { $$ = con_c($1); }
        | STRING                { $$ = con_s($1); }
        | VARIABLE              { $$ = id($1); }
        | VARIABLE '(' expr_list ')' { $$ = call($1, $3);} //call function
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
        | expr AND expr	       	{ $$ = opr(AND, 2, $1, $3); }
        | expr OR expr	      	{ $$ = opr(OR, 2, $1, $3); }
        | '(' expr ')'          { $$ = $2; }
	| VARIABLE array_dmt { $$ = arrayId($1,$2); }
        ;
        
expr_list:
          expr                  { $$ = exprs(1, NULL, $1); }
        | expr_list ',' expr    { $$ = exprs($1->expr.noexpr + 1, $1, $3); }
        | %empty                { $$ = exprs(0, NULL, NULL); } 
        ;

%%

#define SIZEOF_NODETYPE ((char *)&p->con - (char *)p)

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

nodeType *con_c(char value) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(conNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon_c;
    p->con_c.value = value;

    return p;
}

nodeType *con_s(char *value) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(conNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon_s;
    p->con_s.value = value;

    return p;
}

nodeType *arrayId(char *i,arraydim *elem) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(idNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");
   // arraydec* dimension = malloc(sizeof(arraydim));
   // for(int j = 0; j < arraysymbol.size; j++){
    //  if(strcmp(arraysymbol.name[j],i) == 0){
    //       dimension = arraysymbol.dim[j];
      //     break;
       // } 
    //}
    
    /* copy information */
    p->type = typeId;
    p->id.i = i;
   // p->id.dim = dimension;
    p->id.elem = elem;
    p->id.type = array;
    return p;
}

nodeType *arrayDec(char *i, arraydec* dim) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(idNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    p->id.i = i;
    p->id.dim = dim;
    p->id.type = array;
    return p;
}



nodeType *id(char *i) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(idNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    p->id.i = i;
    p->id.type = normal;
    return p;
}

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

nodeType *call(char *name, nodeType *arg){
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(callNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCall;
    p->call.name = name;
    p->call.arg = arg;

    return p;  
}

nodeType *scope(nodeType *stmt){
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(scopeNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeScope;
    p->scope.stmt = stmt;

    return p;  
}

nodeType *exprs(int noexpr, nodeType *old, nodeType *new) {
    nodeType *p;
    size_t nodeSize;
    int i;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(exprsNodeType) +
        (noexpr - 1) * sizeof(nodeType*);
    if ((p = realloc(old, nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeExpr;
    p->expr.noexpr = noexpr;
    if (new != NULL && noexpr > 0){
        p->expr.exprs[noexpr - 1] = new;
    }
    return p;
}


nodeType *func(char *name, nodeType *arg, nodeType *body){
    nodeType *p;
    size_t nodeSize;
    
    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(funcNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");
    
    /* all variable expression list */
    int i;
    for (i = 0; i < arg->expr.noexpr; ++i){
        if (arg->expr.exprs[i]->type != typeId){
            yyerror("function argument definition must be variable");
            exit(1);
        }
    }
    
    /* copy information */
    p->type = typeFunc;
    p->func.name = name;
    p->func.arg = arg;
    p->func.body = body;
    return p;
}

void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOpr) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
    } else if (p->type == typeExpr) {
        for (i = 0; i < p->expr.noexpr; i++)
            freeNode(p->expr.exprs[i]);
    } else if (p->type == typeId){
        free(p->id.i);
    } else if (p->type == typeCon_s){
        free(p->con_s.value);
    } else if (p->type == typeFunc){
        free(p->func.name);
        freeNode(p->func.arg);
        freeNode(p->func.body);
    } else if (p->type == typeCall){
        free(p->call.name);
        freeNode(p->call.arg);
    } else if (p->type == typeScope){
        free(p->scope.stmt);
    }
    free (p);
}

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv) {
    extern FILE* yyin;
    yyin = fopen(argv[1], "r");
    
    context _global;
    _global.nvar = 0;
    _global.fvar = 0;
    _global.vars = NULL;    
    _global.nfunc = 0;
    _global.funcs = NULL;
    _global.outer = NULL;
    global = &_global;
    
    #if YYDEBUG
        yydebug = 1;
    #endif
    yyparse();

    return 0;
}
