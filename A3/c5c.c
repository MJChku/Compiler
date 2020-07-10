#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "c5.h"
#include "y.tab.h"


static int lbl;
typedef struct{
 char* name;
 char* pos;
} elem;
typedef struct{
  elem* table[50];
  int size;
} entry; 

char*  find (char* name,entry* t);
entry* insert(char* name,char* regpos,entry* t);
int ex(nodeType *p, entry* localarg,entry*argu);
void exe(nodeType *p){


	printf("\tpush\tsp\n");
	printf("\tpush\t10\n");
	printf("\tadd\t\n");
	printf("\tpop\tsp\n");
	ex(p,NULL,NULL);

	printf("\tend\n");
}

int ex(nodeType *p, entry *localarg,entry *argu) {
  
    int lblx, lbly, lbl1, lbl2;
    entry* local = (entry*) malloc(sizeof(entry)+1);
    entry* argument = (entry*) malloc(sizeof(entry)+1);
	if (localarg == NULL){
	         local->size = 0;
	}else{
	local = localarg;
	}
	if(argu == NULL){
		argument->size = 0;
	}else{
	     argument = argu;	
	}

    
    char* reg = (char*) malloc(sizeof(char)*6);
    if (!p) return 0;
    switch(p->type) {
   	
    case typeCon:   
        printf("\tpush\t%d\n", p->con.value); 
        break;
    case typeId:
		;

	    char str[6]; 
	    reg = find(p->id.name,local);

	    if ( reg == NULL ){
		reg = find(p->id.name,argument);

	    }
	    if(reg == NULL){	
		sprintf(str,"fp[%d]",local->size);
	    	local = insert(p->id.name,str,local);
	    }
	    if (reg != NULL)        
	       printf("\tpush\t%s\n",reg);
	    else 
	       printf("\tpush\t%s\n",str);
        break;
    case typeOpr:

        switch(p->opr.oper) {
	case FOR:

		ex(p->opr.op[0],local,argument);
		printf("L%03d:\n", lblx = lbl++);
		ex(p->opr.op[1],local,argument);
		printf("\tjz\tL%03d\n", lbly = lbl++);
		ex(p->opr.op[3],local,argument);
		ex(p->opr.op[2],local,argument);
		printf("\tjmp\tL%03d\n", lblx);
		printf("L%03d:\n", lbly);
		break;
        case WHILE:

            printf("L%03d:\n", lbl1 = lbl++);
            ex(p->opr.op[0],local,argument);
            printf("\tjz\tL%03d\n", lbl2 = lbl++);
            ex(p->opr.op[1],local,argument);
            printf("\tjmp\tL%03d\n", lbl1);
            printf("L%03d:\n", lbl2);
            break;
        case IF:

            ex(p->opr.op[0],local,argument);
            if (p->opr.nops > 2) {
                /* if else */
                printf("\tjz\tL%03d\n", lbl1 = lbl++);
                ex(p->opr.op[1],local,argument);
                printf("\tjmp\tL%03d\n", lbl2 = lbl++);
                printf("L%03d:\n", lbl1);
                ex(p->opr.op[2],local,argument);
                printf("L%03d:\n", lbl2);
            } else {
                /* if */
                printf("\tjz\tL%03d\n", lbl1 = lbl++);
                ex(p->opr.op[1],local,argument);
                printf("L%03d:\n", lbl1);
            }
            break;
	case GETS:

	    printf("\tgets\n");
	    break;
	case GETC:

	    printf("\tgetc\n");
	    break;
	case GETI:

	    printf("\tgeti\n");
	    break;
        case PUTI: 

            ex(p->opr.op[0],local,argument);
            printf("\tputi\n");
            break;
	case PUTC:     

            ex(p->opr.op[0],local,argument);
            printf("\tputc\n");
            break;
	case PUTS:     

            ex(p->opr.op[0],local,argument);
            printf("\tputs\n");
            break;
	case PUTI_:     

            ex(p->opr.op[0],local,argument);
            printf("\tputi_\n");
            break;
	case PUTC_:     

            ex(p->opr.op[0],local,argument);
            printf("\tputc_\n");
            break;
	case PUTS_:     

            ex(p->opr.op[0],local,argument);
            printf("\tputs_\n");
            break;
        case '=':       

            ex(p->opr.op[1],local,argument);
	    char str[6];
	    reg = find(p->opr.op[0]->id.name,local);
	    if ( reg == NULL ){
		reg = find(p->opr.op[0]->id.name,argument);
	    }
	    if(reg == NULL){
		sprintf(str,"fp[%d]",local->size);


	    	local = insert(p->opr.op[0]->id.name,str,local);

            }
	    if (reg != NULL)        
               printf("\tpop\t%s\n",reg);
 	    else 
	       printf("\tpop\t%s\n",str);
            //printf("\tpop\t%c\n", p->opr.op[0]->id.i + 'a');
            break;
        case UMINUS: 
	   
            ex(p->opr.op[0],local,argument);
            printf("\tneg\n");
            break;
        case RETURN:
	   
	    ex(p->opr.op[0],local,argument);
	    return 1;
	    printf("\tRET\n");
	    break;
        default:
            ex(p->opr.op[0],local,argument);
            ex(p->opr.op[1],local,argument);
            switch(p->opr.oper) {
            case '+':   printf("\tadd\n"); break;
            case '-':   printf("\tsub\n"); break; 
            case '*':   printf("\tmul\n"); break;
            case '/':   printf("\tdiv\n"); break;
            case '%':   printf("\tmod\n"); break;
            case '<':   printf("\tcompLT\n"); break;
            case '>':   printf("\tcompGT\n"); break;
            case GE:    printf("\tcompGE\n"); break;
            case LE:    printf("\tcompLE\n"); break;
            case NE:    printf("\tcompNE\n"); break;
            case EQ:    printf("\tcompEQ\n"); break;
	    case AND:   printf("\tand\n"); break;
	    case OR:    printf("\tor\n"); break;
            }

        }
	break;
 
      case typeFunc:
	   
	;
	paramlist* arg;
	paramlist* param; 
	arg = (paramlist*)malloc(sizeof(paramlist));
	param = (paramlist*)malloc(sizeof(paramlist));
	arg = p->funcNode.init;
	param = p->funcNode.func->localval;
	char* regpos;       
	int i = 0;
 	entry* funcargu = NULL; 
	if(arg->size != param->size ){ 
	//print errors size  not equal;
	}
	for(int i =0;i<arg->size;i++){
		   ex(arg->name[i],local,argument);
		   char str[6];		   
		   sprintf(str,"fp[%d]",i - param->size-3);
		   funcargu = insert(param->name[i]->id.name,str,funcargu);		
	
//		regpos = find(arg->name[i],local);
//		if(regpos == NULL){
//			regpos = find(arg->name[i],argument);
//			if(regpos == NULL){;}
//			//print error argument doesn't exists;	
//		}
//		if(regpos != NULL)
//		{
//		   printf("\tpush\t%s\n",regpos);
//		   char str[6];		   
//		   sprintf(str,"fp[%d]",i - param->size-3);
//		   argument = insert(param->name[i],str,argument);		
//		}
//	}	
	printf("\tcall\tL%03d,%d\n", ++lbl,arg->size);
        printf("L%03d:\n", lbl2);
	printf("\tpush\tsp\n");
	printf("\tpush\t10\n");
	printf("\tadd\t\n");
	printf("\tpop\tsp\n");
	ex(p->funcNode.func->stmt,NULL,funcargu);
	argument->size = 0;
	lbl--;
	break;       
    }
    return 0;
}

char*  find (char* name,entry* t){
   if(t == NULL) return NULL;
   for(int i = 0;i<t->size;i++){
   	if(strcmp(name,t->table[i]->name) == 0)
	    return t->table[i]->pos;  
  }
    return NULL;
}

entry* insert(char* name,char* regpos,entry* t){
	if(t == NULL){
	   t = (entry*)malloc(sizeof(entry));	
	   t->size = 0;
	}
	elem* insertone = (elem*) malloc(sizeof(elem));
	insertone->name = (char*) malloc(sizeof(char)*12);
	insertone->pos = (char*) malloc(sizeof(char)*6);	
	strcpy(insertone->name,name);
	strcpy(insertone->pos,regpos);	
	t->table[t->size++]=insertone;
	return t;
}


