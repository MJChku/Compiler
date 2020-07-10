#include <string.h>
#include <stdlib.h>
#include <stdio.h>

typedef struct {
  char* name[100];
  int length = 0;
    
} vector;


void print(char*  a){
   printf("X: 1 \nT: \nL: 1/4 \nK: G \n");
   int i = 0;
   for (char* t = a; *t != '\0'; t++) {
     printf("%c",*t);
     if (i > 40 && *t == ' '){
             printf("%c",'\n');
             i = 0;
     }   
     i++;
    }
    printf("\n");
}
//not used
void addName(vector* array, char* newone){
	for(int i = 0;i < (*array).length;i++){
		if ( strcmp((*array)[i],newone) == 0) {
			printf("duplicate \n");		
		}	
   	}
	(*array)[(*array).length++] = newone;
}
