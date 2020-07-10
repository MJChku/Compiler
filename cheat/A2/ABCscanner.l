%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include "ABCparser.tab.h"

%}
%x STAG

%%

[ \t\n]	; // ignore all whitespace

[drmfsltDRMFSLT0] {yylval.note = yytext;return NOTE;}


"!"  |
"/"  |
"\\" |
">"  |
"<"         {return yytext[0];}
[-]+        {yylval.note = yytext; return ENLONG;}

"("    {BEGIN(STAG);yylval.tag = yytext;return BTAG;}
")"    {yylval.tag = yytext;return ETAG;}
"@"    {BEGIN(STAG);yylval.tag = yytext;return TAG; }
<STAG>[0-9] {BEGIN(INITIAL);yylval.integer = atoi(yytext);return TAGNUM;}

<STAG,INITIAL>.  
<STAG>[ \t\n]  

%%
