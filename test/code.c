#include <string.h>
#include <stdlib.h>
#include <stdio.h>

typedef struct {
   int name[4];
   
} list;

typedef struct inst{
 int name;
 int param[6];
 int size;
  struct inst* next;

}instruction;



void ex(instrution* list){
   instruction* temp;
   while(list != NULL){
      temp = list;
      switch(temp->name){
         case PLOT:
            plot();
            break;
         case MOVE:
            int a[6] = list->param;
            break;
         case LINE:
            int a[6] = list->param;
            line(a[0],a[1],a[2],a[3]);
            break;
         case START:
            init_bed();
            break;
         case DISPLAY:
            display_bed();
            break;
         case REPEAT:
            for(int i=0; i< list->param[0]; i++){
               ex(temp->block);
            }
            break;
         default:;
      }

   } 

	






}

}


instruction* funcOpr(int type, int times, instruction* list);
instruction* concatInstruction(instruction* pre, instruction* next);
instruction* opr(int name, int nops, ...);
void init_bed();
void display_bed() ;
void move(int dx,int dy);
void line(int a,int b,int c,int d);
void plot();
void ex(instrution* list);