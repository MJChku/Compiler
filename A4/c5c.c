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

static entry* functable;
char*  find (char* name,entry* t);
entry* insert(char* name,char* regpos,entry* t);
int ex(nodeType *p, entry* localarg,entry*argu);
void getics(nodeType *p, entry *localarg,entry *argu);
void exe(nodeType *p){
	functable = (entry*) malloc(sizeof(entry)+1);
	printf("\tpush sp  push 20  add  pop sp\n");
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
	switch(p->con.type){
	case INT:
		printf("\tpush\t%d\n", p->con.value); 
	break;
	case CHARC:
	printf("\tpush\t\'%s\'\n", p->con.cValue);
	break;
	case STR:
	printf("\tpush\t\"%s\"\n", p->con.cValue);

	default:    
        break;
	}
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
		printf("\tj0\tL%03d\n", lbly = lbl++);
		ex(p->opr.op[3],local,argument);
		ex(p->opr.op[2],local,argument);
		printf("\tjmp\tL%03d\n", lblx);
		printf("L%03d:\n", lbly);
		break;
        case WHILE:

            printf("L%03d:\n", lbl1 = lbl++);
            ex(p->opr.op[0],local,argument);
            printf("\tj0\tL%03d\n", lbl2 = lbl++);
            ex(p->opr.op[1],local,argument);
            printf("\tjmp\tL%03d\n", lbl1);
            printf("L%03d:\n", lbl2);
            break;
        case IF:

            ex(p->opr.op[0],local,argument);
            if (p->opr.nops > 2) {
                /* if else */
                printf("\tj0\tL%03d\n", lbl1 = lbl++);
                ex(p->opr.op[1],local,argument);
                printf("\tjmp\tL%03d\n", lbl2 = lbl++);
                printf("L%03d:\n", lbl1);
                ex(p->opr.op[2],local,argument);
                printf("L%03d:\n", lbl2);
            } else {
                /* if */
                printf("\tj0\tL%03d\n", lbl1 = lbl++);
                ex(p->opr.op[1],local,argument);
                printf("L%03d:\n", lbl1);
            }
            break;
	case GETS:
	    printf("\tgets\n");
	    getics(p->opr.op[0],local,argument);
	    break;
	case GETC:
	    printf("\tgetc\n");
	    getics(p->opr.op[0],local,argument);
	    break;
	case GETI:
	    printf("\tgeti\n");
	    getics(p->opr.op[0],local,argument);
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
            break;
        case UMINUS: 
	   
            ex(p->opr.op[0],local,argument);
            printf("\tneg\n");
            break;
        case RETURN:
	    ex(p->opr.op[0],local,argument);
	    printf("\tret\n");
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
     	case typeArray: ;
		list* dim = p->arrayNode;
		
 	
      	case typeFunc: ;
		paramlist* arg = (paramlist*)malloc(sizeof(paramlist));
		arg = p->funcNode.init;
		entry* funcargu = NULL; 
		for(int i =0;i<arg->size;i++){
			ex(arg->name[i],local, argument);		
		}	
		char* lable = (char* )malloc(sizeof(char*)*20);
		lable = find(p->funcNode.name,functable);
		if ( !lable ){
			lable = (char* )malloc(sizeof(char*)*20);
			sprintf(lable,"L%03d", lbl++);
			functable = insert(p->funcNode.name,lable, functable);
		}
		printf("\tcall\t%s,%d\n", lable,arg->size);
		break;       
    }
    return 0;
}

void layoutf(function* func ){
	char* lable = (char* )malloc(sizeof(char*)*20);
	lable = find(func->name,functable);
	if(!lable) return;
	paramlist* param = (paramlist*)malloc(sizeof(paramlist));
	param = func->localval;
	char* regpos;       
	int i = 0;
 	entry* funcargu = NULL; 
	for(int i =0;i<param->size;i++){
		char str[6];		   
		sprintf(str,"fp[%d]",i - param->size-3);
		funcargu = insert(param->name[i]->id.name,str,funcargu);		
	}
	
	printf("%s:\n", lable);	
	printf("\tpush sp  push 20  add  pop sp\n");
	ex(func->stmt,NULL,funcargu);
	printf("\n");
	
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

void getics(nodeType *p, entry *local,entry *argument){
            char str[6];
	    char* reg = (char*) malloc(sizeof(char)*6);
	    reg = find(p->id.name,local);
	    if ( reg == NULL ){
		reg = find(p->id.name,argument);
	    }
	    if(reg == NULL){
		sprintf(str,"fp[%d]",local->size);
	    	local = insert(p->id.name,str,local);
            }
	    if (reg != NULL)        
               printf("\tpop\t%s\n",reg);
 	    else 
	       printf("\tpop\t%s\n",str);
}

list* newlist(int a){
	list newlist;
	newlist.dimint = a;
 	newlist.next = NULL;
	return  &newlist;
}

void freelist(list* a){
	list* temp;	
	while(a.next != NULL){
		temp = a;
		a = a.next;
		free(temp);	
	}
}

void list_insert(list* a, int b){
	list next;
	next.dimint = b;
	next.next = NULL;
	a->next = next;  
}

nodeType* listnode(char* name, list* dim){
	nodeType a;
	arrayNode node;
	node.list = dim;
	sprintf(node.name,"%s",name);
	a.type = typeArray;
	a.arraylist = dim; 
	a.
	return a;
}
