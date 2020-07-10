
%{
  int sentence = 0;
  int words = 0;
  int max = 0;
%}

%s quote

%%	


[ \t\n]	

Ms\.|Mr\.|Mrs\.   ++words;

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
  printf("sentense=%d max=%d", sentence,  max);
  exit(0);
}
