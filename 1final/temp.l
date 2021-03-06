/*
 * a1 question2
 */

%{
  #include<stdio.h>
  #include <stdlib.h>

  int tempx = 0;
  int tempy = 0;
  int lineleng = 0;
  int nums = 0;
  int num = 0;
  typedef struct {
  int *arrayx;
  int *arrayy;
  size_t used;
  size_t size; 
  } Array;

  void initArray(Array *a, size_t initialSize) {
    a->arrayx = (int *)malloc(initialSize * sizeof(int));
    a->arrayy = (int *)malloc(initialSize * sizeof(int));
    a->used = 0;
    a->size = initialSize;
  }
  void deleteArray(Array *a){
    a->used--;
  }

  void insertArray(Array *a, int elementx, int elementy) {
    if (a->used == a->size) {
      a->size *= 2;
      a->arrayx = (int *)realloc(a->arrayx, a->size * sizeof(int));
      a->arrayy = (int *)realloc(a->arrayy, a->size * sizeof(int));
    }
    a->arrayx[a->used] = elementx;
    a->arrayy[a->used] = elementy;
    a->used++;
  }

  void freeArray(Array *a) {
    free(a->arrayx);
    free(a->arrayy);
    a->arrayx = NULL;
    a->arrayy = NULL;
    a->used = a->size = 0;
  }
  Array core;

  typedef struct {
    int *array;
    size_t used;
    size_t size; 
  } Record;
  void initRecord(Record *a, size_t initialSize) {
    a->array = (int *)malloc(initialSize * sizeof(int));
    a->used = 0;
    a->size = initialSize;
  }
  void insertRecord(Record *a, int element) {
    if (a->used == a->size) {
      a->size *= 2;
      a->array = (int *)realloc(a->array, a->size * sizeof(int));
    }
    a->array[a->used] = element;
    a->used++;
  }

  Record record;

 
%}

%s STEP

%%
		{
		initArray(&core, 30);
		initRecord(&record, 10);
		BEGIN(INITIAL);
		}		
<INITIAL>\n/(.|\n) 	 tempx = 0;lineleng = yyleng;tempy++;yymore();
		

<INITIAL>\.*	 tempx = yyleng - lineleng; yymore();
<INITIAL>@	{
               
		  if(core.used == 0){
		    if (num != 0){ insertRecord(&record,num); num = 0;}

		    insertArray(&core, tempx, tempy);
		    num++;
		    int i;
	  	    unput('.');
		    tempx = 0; tempy = 0;
	  	    for ( i = yyleng - 2; i >= 0; --i )
    	    	      unput( yytext[i]);

		  }else{
		     int corex = core.arrayx[core.used-1];
 		     int corey = core.arrayy[core.used-1];
		   if(abs(tempx-corex)<=1 && abs(tempy-corey)<=1){
			 
			  num++;
			  insertArray(&core, tempx, tempy);
		          tempx = 0; tempy = 0;
			  int i; unput('.'); for ( i = yyleng - 2; i >= 0; --i ) {unput( yytext[i]);}
			  
		   }else{
			  if (tempy - corey > 1){
			    //signal terminate
			    deleteArray(&core); 
			    tempx = 0; tempy = 0;
			    yyless(0);
			    
			  }else{
			   yymore();
			  }
		
		        }
		   }
		} 



<INITIAL>\n	             {		 
			  if(core.used == 0){
				if (num != 0){ 
				  insertRecord(&record,num);
				} 
				yyterminate();
		       	  }
		  	  if(core.used != 0){
                                deleteArray(&core);
				tempx =0; tempy = 0;
				yyless(0);	
			  }
			   
			}

%%

int main(int argc, char *argv[]) {
  if ( argc > 1 ) {
    if ( (yyin = fopen(argv[1], "r")) == 0 ) {
      perror(argv[1]);
      exit(1);
    }
  }
  yylex();
  int sum = 0;
  int size = (int) record.used;
  printf("There are %d islands, sizes are ", (int)record.used);
  for( int i = 0;i < size; i++){ sum +=record.array[i]; printf("%d,", record.array[i]);}
   
  double ave = (double)sum/size;
  printf("respectively. Average size is %.2f", ave);
 
      
  exit(0);
}
