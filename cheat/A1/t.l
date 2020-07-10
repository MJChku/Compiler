/*
 * wc - word (and line and char) count
 * flex wc.l ; gcc -o mywc lex.yy.c -lfl ; ./mywc
 */

%{
  #include <stdlib.h>
  int x[400];
  int y[400]; 
  int tempx = 0;
  int tempy = 0;
  int numPiece = -1;

%}

%%

\n		tempx += 40; tempy += 1;
\.*		tempx += yyleng;
@		++numPiece; x[numPiece] = tempx; y[numPiece] = tempy;		
.

%%

int main(int argc, char *argv[]) {
  if ( argc > 1 ) {
    if ( (yyin = fopen(argv[1], "r")) == 0 ) {
      perror(argv[1]);
      exit(1);
    }
    	   
    int groupInfo[100] = { -1 };
    int num = 0;
    groupInfo[0] = 0;
    groupSize[100] = 0;
    groupNum[100] = -1;
    for(int current = 1; current <= numPiece; current++){
	for (int i = 0; i<current; i++){
	  if (examAdj(x[i],y[i],x[current],y[current]))
	     int info = gruopInfo[i];
             if (groupInfo[currrent] >=0 ) {
		groupInfo[i] = groupInfo[current];
		for( int j = 0; j<current; j++){
		  if (groupInfo[j] == info) 
		     groupInfo[j] = groupInfo[current];		
		}		
	     } 
	     else
	       groupInfo[current] = info;	
	}	    
     }
     for ( int i = 0; i <= numPiece; i++ ){
	int info = groupInfo[i];
        for (int j = 0; j <= numPiece; j++){
	   
        }

      }

  }
  yylex();
  printf("numpiece = %d", numPiece);
  exit(0);
}

bool examAdj(int x1, int x2,int y1,int y2){
  if (abs(x1-x2) <= 1 && abs(y1-y2) <= 1){
    return true;
  } return false;
}
