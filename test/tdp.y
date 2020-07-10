%{
  #include <stdio.h>  /* For printf, etc. */
  #include <string.h>
  #include <stdlib.h>
  #include <stdarg.h>
  #include "tdp.h"
  #define YYDEBUG 0
  #define N 20
  #define plot bed[x][y] = '*';

char bed[N][N];
int x = N/2, y =N/2; 

int yylex(void);
void yyerror (char *s);
instruction* funcOpr(int type, int times, instruction* list);
instruction* concatInstruction(instruction* pre, instruction* next);
instruction* opr(int name, int nops, ...);
void init_bed();
void line2(int c, int d);
void display_bed() ;
void move(int dx,int dy);
void line(int a,int b,int c,int d);
void plot_current();
void ex(instruction* list);

//TODO declare functions HERE  
%}

%union { 
 int iValue;
 instruction *node;
};


%token <iValue> INT
%token MOVE LINE START DISPLAY REPEAT EMPTY PLOT LINE2
 
%type <node> stmtlist stmt expr




%% /* The grammar follows.  */

program: stmtlist			{ex($1);}
	;

stmtlist:
	stmt 		              {$$ = $1;}									
        | stmtlist stmt               { $$ = concatInstruction($1,$2);}
	;
stmt:
          //';'                            { $$ = opr(EMPTY, 2, NULL, NULL);}
          expr ';'                       { $$ = $1; }
	| REPEAT '(' INT ')' '{' stmtlist '}'	 { $$ = funcOpr(REPEAT,$3,$6); }
        ;
expr:
	  START 	             { $$=opr(START,0); }
	| MOVE  '(' INT ',' INT ')'  { $$=opr(MOVE,2,$3,$5);}
	| PLOT   			  {$$=opr(PLOT,0);} 
	| LINE INT INT INT INT  {$$=opr( LINE,4,$2,$3,$4,$5);}
	| DISPLAY	      { $$=opr(DISPLAY,0);}
        | LINE2 INT INT {$$=opr(LINE2,2,$2,$3);}
        ;

%%

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

instruction* funcOpr(int type, int times, instruction* list){
    instruction *p;
    p = malloc(sizeof(instruction));
    p->name = type;
    p->param[0] = times;
    p->size = 1;
    p->next = NULL;
    p->block = malloc(sizeof(instruction));
    p->block = list;
 
}


instruction* concatInstruction(instruction* pre, instruction* next){
   next->next = pre;
   return next;
   instruction *iter = malloc(sizeof(instruction));
   iter = pre;
    while(iter->next != NULL){
       iter=iter->next;
    }
    iter->next = malloc(sizeof(instruction));
    iter->next = next;
    if (pre->next )
    return pre;
}

instruction* opr(int name, int nops, ...){
    va_list ap;
    instruction *p;
    p = malloc(sizeof(instruction));
    p->name = name;
    p->size = nops;
    p->next = NULL;
    va_start(ap, nops);
    for (int i = 0; i < nops; i++)
        p->param[i] = va_arg(ap, int);
    va_end(ap);
    return p;

}

void init_bed() {
 int i, j;
 for (i=0; i<N; i++)
 for (j=0; j<N; j++) bed[i][j] = '.'; // for easy visualization
}

void display_bed() {
 int i, j;
 for (i=N-1; i>=0; i--) {
 for (j=0; j<N; j++){
 putchar(bed[i][j]);
 putchar(' ');
 }
 putchar('\n');
 }
}

void move(int dx,int dy){
	x+= dx;
        if(x>=N || x< 0) x = N/3;
	y+=dy;
        if (y>=N || y<0) y = N/3;
}

void line2(int a, int b){
     int c = x; int d = y;
     for(int i=a;i<b;i++){
	  {
	    bed[i][c]='*';
	    c++;
            if(c>=d) break;
          }	
	}		

}

void line(int a,int b,int c,int d){
	for(int i=a;i<b;i++){
	  {
	    bed[i][c]='*';
	    c++;
            if(c>=d) break;
          }	
	}		
}

void plot_current(){
   bed[x][y]='*';
}	


void ex(instruction* list){
   instruction* temp;
   while(list != NULL){
      temp = list;
      switch(temp->name){
         case PLOT:
            plot_current();
            break;
         case MOVE:;
	    move(list->param[0],list->param[1]);
            break;
         case LINE2:;
            line2(list->param[0],list->param[1]);
            break;
         case LINE:;
            int* a = list->param;
            line(a[0],a[1],a[2],a[3]);
            break;
         case START:
            init_bed();
            break;
         case DISPLAY:
            display_bed();
            break;
         case REPEAT:
            for(int i=0; i< list->param[0]; i++){
               ex(temp->block);
            }
            break;
         default:;
      }
     list = list->next;
  
   }
} 


