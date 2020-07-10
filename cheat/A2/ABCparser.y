%{
  #include <stdio.h>  /* For printf, etc. */
  #include <string.h>
  #include <stdlib.h>
  #include "a3.h"
  #define YYDEBUG 0

  char* tag[10] ;
  int yylex(void);
  void yyerror (char const *);
  
%}

%union {
  char* note;
  char* symbol;
  char* tag;
  int integer;
}

%token <note> NOTE
%token <note> ENLONG 
%token <tag> BTAG
%token <tag> ETAG 
%token <tag> TAG
%token <integer> TAGNUM

%type  <symbol> expr note beat completetag tagseq program
%type <integer> modifier

%right '/' '\\'
%right '!' '>' 


%start program

%% /* The grammar follows.  */
program:
expr { $$ = $1; print($$); exit(0); }
;


expr: //expr '\n' {$$ = cancf($1,"\n");} 
   beat   { $$ = $1; } 
 | expr beat { $$ = cancf($1,$2); } 
 | expr tagseq { $$ = cancf($1,$2); }
 | expr completetag {$$ = cancf($1,$2);}
 | completetag {$$ = $1;}

 ;
beat: note { $$ = cancf($1," "); }
 | '!' note note     {$$ = cancf( canc($2,$3, "exclaim")," ");}
 | '!' note '>' note {$$ = cancf( canc($2,$4, "gt"), " ");}
 | '!' note '<' note {$$ = cancf( canc($2,$4, "lt"), " ");}
 | note '<' note {$$ = cancf(canc2($1,"<",$3,"dummy")," ");}
 | note '>' note {$$ = cancf( canc2($1,">",$3,"dummy"), " ");}

;

note: 
 NOTE { $$ = s2ABC($1); }
 |'/' NOTE {$$ = canc3("up", s2ABC($2));}
 | '\\' NOTE {$$ = canc3("down", s2ABC($2));}
 | NOTE modifier { $$ = canc4(s2ABC($1), $2);}
;


modifier:
 ENLONG { $$ = strlen($1); }
;

completetag: BTAG TAGNUM expr ETAG { int i = $2;char* news = malloc(sizeof(char)*(strlen($3)+1));news=$3; tag[i] = news; $$ = $3; }
;

tagseq: TAG TAGNUM { $$=tag[$2];}
;

%%

void yyerror(char const*s)
{
  fprintf(stderr, "error: %s\n", s);
}


int main ()
{
    #if YYDEBUG
        yydebug = 1;
    #endif
 
   return yyparse ();
}

