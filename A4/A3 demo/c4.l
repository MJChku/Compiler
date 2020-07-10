%{
#include <stdlib.h>
#include "calc3.h"
#include "y.tab.h"
void yyerror(char *);
%}


CHARCONSTANT (['](([\\]['])|([^']))['])
STRINGLITERAL (["](([\\]["])|([^"]))*["])
IDENTIFIER [a-zA-Z][_a-zA-Z0-9]*

%%

{IDENTIFIER}   { yylval.dValue = *yytext;
		return VARIABLE; }
{STRINGLITERAL} {char* to = malloc(sizeof(char)*(strlen(yytext)-1)) 
	      	strncpy(to, 1, strlen(yytext)-1);
         	yylval.sValue = to;
                return STRING;
	}
{CHARCONSTANT}     {
		 char* to = malloc(sizeof(char)*(strlen(yytext)-1)) 
	      	strncpy(to, 1, strlen(yytext)-1);
         	yylval.cValue = to;
                return CHAR;
             }


'[a-zA-Z]'     { char* to = malloc(sizeof(char)*(strlen(yytext)-1)) 
	      strncpy(to, 1, strlen(yytext)-1);
         	yylval.cValue = to;
                return CHAR;
            }

[a-z]       { 
                yylval.sIndex = *yytext - 'a';
                return VARIABLE;
            }

0           {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

[1-9][0-9]* {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

[-()<>=+*/;{}.%] {
                return *yytext;
             }

">="            return GE;
"<="            return LE;
"=="            return EQ;
"!="            return NE;
"for"		return FOR;
"while"         return WHILE;
"if"            return IF;
"else"          return ELSE;
"puti"          return PUTI;
"putc"		return PUTC;
"puts"		return PUTS;
"puti_"         return PUTI_;
"putc_"		return PUTC_;
"puts_"		return PUTS_;
"geti"		return GETI;
"getc"		return GETC;
"gets"		return GETS;
"&&"		return AND;
"||"		return OR;

\/\/.*\n	;	/* skip comments */

[ \t\n]+        ;       /* ignore whitespace */

.               yyerror("Unknown character");
%%
int yywrap(void) {
    return 1;
}
