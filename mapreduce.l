%{
#include <stdlib.h>
#include <string.h>

float map = 0;
float reduce = 0;
%}

%x MAP REDUCE 

CHARCONSTANT (TPCH1|TPCH4|TPCH6|KM|LR|TPCH11|TPCH21|TPCH13)
digit [0-9]
integer {digit}+
real ({digit}+[.]{digit}*)|({digit}*[.]{digit}+)
exp ({integer}|{real})[eE]-?{integer}
whatever ({integer}|{real}|{exp})

%%

[ \t\n]

{CHARCONSTANT} { 
                  printf("%s ",yytext);
               }

(original|lineitem|partsupp)[_A-Za-z0-9]+ {  printf("%s", yytext); } 

"map"     {BEGIN(MAP);}
"reduce"  {BEGIN(REDUCE);}

<MAP>{whatever} { map += atof(yytext); BEGIN(INITIAL);}
<REDUCE>{whatever} { reduce += atof(yytext); BEGIN(INITIAL);}
"Execution" {printf("map: %.6f ",map); printf("reduce: %.6f \n",reduce);}
.
        
%%
int yywrap(void) {
    return 1;
}

int main(int argc, char *argv[]) {
  if ( argc > 1 ) {
    if ( (yyin = fopen(argv[1], "r")) == 0 ) {
      perror(argv[1]);
      exit(1);
    }
  }
  yylex();
  exit(0);
}
