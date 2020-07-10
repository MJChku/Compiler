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


%%
		{
		initArray(&core, 20);
		initRecord(&record, 10);
		BEGIN(INITIAL);
		}		
<INITIAL>\n/(.|\n) 	 tempx = 0;lineleng = yyleng;tempy ++;yymore();
		

<INITIAL>\.*	 tempx = yyleng - lineleng; yymore();
<INITIAL>@	{
		  tempx++;
		  printf("find x=%d,y=%d,\n",tempx,tempy);
               
		  if(core.used == 0){
		    if (num != 0){ insertRecord(&record,num); num = 0;}

		    insertArray(&core, tempx, tempy);
		    printf("insert corex=%d,corey=%d,\n",tempx,tempy);
		    num++;
		    int i;
	  	    unput('.');
		    tempx = 0; tempy = 0;lineleng = 0;
	  	    for ( i = yyleng - 2; i >= 0; --i )
    	    	      unput( yytext[i]);

		  }else{
		    int find = 0;
		    for ( int i = 0; i < core.used; i++){
		      int corex = core.arrayx[i];
 		      int corey = core.arrayy[i];
		      if(abs(tempx-corex)<=1 && abs(tempy-corey)<=1){
			  printf("tempx=%d,tempy=%d,corex=%d,corey=%d,\n",tempx,tempy,corex,corey);
			  num++;
			  insertArray(&core, tempx, tempy);
			  printf("insert corex=%d,corey=%d,\n",tempx,tempy);
		          tempx = 0; tempy = 0; lineleng = 0; find = 1;
			  int i; unput('.'); for ( i = yyleng - 2; i >= 0; --i ) {unput( yytext[i]);}
			  break;
			}
			  
		     }
		     if (find == 0 ) { yymore();}
		   }
		} 



<INITIAL>\n	             {		 
			  if(core.used == 0){
				if (num != 0){ 
				  insertRecord(&record,num);
				  printf("insert record,\n");
				} 
				yyterminate();
		       	  }
		  	  if(core.used != 0){
                                deleteArray(&core);
				printf("delete core,\n");
				tempx =0; tempy = 0; lineleng=0;
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
