%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include "tdp.h"
#include "y.tab.h"

%}


%%

[ \t\n]	; // ignore all whitespace

[-]?[0-9][0-9]* {
                yylval.iValue = atoi(yytext);
                return INT;
            }
\/\/.*\n	;	/* skip comments */

"line_"           return LINE2;
"draw"		  return PLOT;	
"start" 	  return START;
"move"            return MOVE;
"line"            return LINE;
"display"         return DISPLAY;
"repeat"	  return REPEAT;
	
[{}();,]         return *yytext;
                     
.               //yyerror("Unknown character");

%%
