/*
 * a1 question1
 * it is very  hard to distinguish between abberivation like " Sep. Mrs." TO locations appearing at the end, like "I live in Boston."
 * I restrict the length of Abberivation  of this kind ( end with single dot ) at 4 for this reason.
 * It's a very bad practice though,e.g. " I live in Bost. Where do you live? " will be regconised as one sentence and probably will be the   
 * longest. 
 */

%{
  int sentence = 0;
  int words = 0;
  int max = 0;
%}

%s quote

char_w_with_dot  (([a-zA-Z0-9#$%^\-()=+_`~’<>,'\|]+)|\.)+[a-zA-Z0-9#$%^\-()=+_`~’<>,'\|]+
char_w_pure  [a-zA-Z0-9#$%^\-()=+_`~’<>,'\|]+
special_abbreviation [a-zA-Z]\.([a-zA-Z]\.)+
special_abbreviation_2 [A-Z][a-z]{1,3}\.

%%	


[ \t\n]	

<INITIAL>\"	{ 
	  	BEGIN(quote);
		}

[#$%^\-()=+_`~’<>,'\|]+
			
{char_w_with_dot}	    ++words;

{char_w_pure}         	    ++words;

{special_abbreviation}      ++words;

{special_abbreviation_2}    ++words;



<quote>\"	BEGIN(INITIAL);
<quote>[.?!]+\"	{
		++sentence;
		if( max < words) max = words;
		 words = 0;
		BEGIN(INITIAL);
		}


[.!?]+		{ 
		++sentence;
		if( max < words) max = words;
		words = 0;
		}
		
.		

%%

int main(int argc, char *argv[]) {
  if ( argc > 1 ) {
    if ( (yyin = fopen(argv[1], "r")) == 0 ) {
      perror(argv[1]);
      exit(1);
    }
  }
  yylex();
  printf("sentense count=%d \nlength of longest sentense=%d words\n", sentence,  max);
  exit(0);
}
