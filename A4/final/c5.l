%{
#include <stdlib.h>
#include "c5.h"
#include "y.tab.h"
#include <string.h>
void yyerror(char *);
%}


CHARCONSTANT (['](([\\]['])|([^']))['])
STRINGLITERAL (["](([\\]["])|([^"]))*["])
IDENTIFIER [a-zA-Z][_a-zA-Z0-9]*

%%


0           {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

[1-9][0-9]* {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

[-()<>=+*/;{}.,%] {
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
"return"	return RETURN;



{IDENTIFIER}   {
                char* to = (char*) malloc(sizeof(char)*strlen(yytext)); 
                sprintf(to,"%s",yytext);
		yylval.sIndex = to;
		return VARIABLE; }

{STRINGLITERAL} {
		
                char* to = (char*) malloc(sizeof(char)*strlen(yytext));
		//strcpy(to,yytext);
	        for(int i=1;i<strlen(yytext)-1;i++){ sprintf(to,"%s%c",to,yytext[i]);}
         	yylval.sValue = to;
                return STRING;
		}

{CHARCONSTANT}   {
		char* to = (char*) malloc(sizeof(char)*strlen(yytext));
	        //strcpy(to,yytext);
		for(int i=1;i<strlen(yytext)-1;i++){ sprintf(to,"%s%c",to,yytext[i]);}
         	yylval.cValue = to;
                return CHAR;
                }
	
\/\/.*\n	;	/* skip comments */

[ \t\n]+        ;       /* ignore whitespace */

.               yyerror("Unknown character");
%%
int yywrap(void) {
    return 1;
}
