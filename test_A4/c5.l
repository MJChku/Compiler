%{
#include <stdlib.h>
#include "calc3.h"
#include "y.tab.h"
void yyerror(char *);
%}

IDENTIFIER [a-z][a-zA-Z0-9]{0,11}

%%



\'\'        {
                yylval.cValue = '\0';
                return CHARACTER;                
            }
            
\"\"      {
                
                yylval.sValue = malloc(sizeof(char));
                yylval.sValue[0] = '\0';
                return STRING;                
            }               
            
\'.\'       {
                yylval.cValue = yytext[1];
                return CHARACTER;                
            }
            
\'\\.\'     {
                switch(yytext[2]){
                    case 'a':
                        yylval.cValue = '\a';
                        break;
                    case 'b':
                        yylval.cValue = '\b';
                        break;
                    case 'f':
                        yylval.cValue = '\f';
                        break;
                    case 'n':
                        yylval.cValue = '\n';
                        break;
                    case 'r':
                        yylval.cValue = '\r';
                        break;
                    case 't':
                        yylval.cValue = '\t';
                        break;
                    case 'v':
                        yylval.cValue = '\v';
                        break;
                    case '\\':
                        yylval.cValue = '\\';
                        break;
                    case '\'':
                        yylval.cValue = '\'';
                        break;                                            
                }
                
                return CHARACTER;                
            }            
            
            
\".+\"       {
                
                yylval.sValue = malloc(sizeof(char) * (strlen(yytext) - 1));
                strncpy(yylval.sValue, yytext + 1, strlen(yytext) - 2);
                yylval.sValue[strlen(yytext) - 2] = '\0';
                return STRING;                
            }            
            
                

0           {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

[1-9][0-9]* {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

[-()<>=+*/;{}.%,\[\]] {
                return *yytext;
             }

">="            return GE;
"<="            return LE;
"=="            return EQ;
"!="            return NE;
"for"		    return FOR;
"while"         return WHILE;
"if"            return IF;
"else"          return ELSE;
"puti"      { return PUTI; }
"putc"      { return PUTC; }
"puts"      { return PUTS; }
"puti_"     { return PUTI_; }
"putc_"     { return PUTC_; }
"puts_"     { return PUTS_; }        
"geti"      { return GETI; }
"getc"      { return GETC; }
"gets"      { return GETS; }
"return"    { return RETURN; }
"array"     {return ARRAY;}
          

{IDENTIFIER}                 { 
                                  yylval.sIndex = malloc(sizeof(char) * (strlen(yytext) + 1));
                                  strncpy(yylval.sIndex, yytext, strlen(yytext));
                                  yylval.sIndex[strlen(yytext)] = '\0';
                                  return VARIABLE;
                              }


"&&"		return AND;
"||"		return OR;

\/\/.*\n	;	/* skip comments */

[ \t\n]+        ;       /* ignore whitespace */

.               yyerror("Unknown character");
%%
int yywrap(void) {
    return 1;
}
