#include <stdio.h>
#include "calc3.h"
#include "y.tab.h"

static int lbl;
typedef struct{
 char* name;
 char* pos;
} elem;
typedef struct{
  elem* table[50];
  int size = 0;
} entry; 

void exe(nodeType *p){
	ex(p,NULL,NULL);
	printf("\tend\n");
}

int ex(nodeType *p, entry* localarg,entry*argument) {
    int lblx, lbly, lbl1, lbl2;
    entry* local = localarg == NULL ? (entry*) malloc(sizeof(entry)+1) : localarg;
    entry* argument = argument == NULL ? (entry*) malloc(sizeof(entry)+1) : argument;
    
    char* reg = (char*) malloc(sizeof(char)*6);
    
    if (!p) return 0;
    switch(p->type) {
   	
    case typeCon:       
        printf("\tpush\t%d\n", p->con.value); 
        break;
    case typeId:

	    char str[6];
	    reg = find(p->id.name,argument);
	    if ( reg == NULL ){
		reg = find(p->opr.op[0]->id.name,argument);
	    }
	    if(reg == NULL){	
		sprintf(str,"fp[%d]",local->size);
	    	local = insert(p->opr.op[0]->id.name,str,local)
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
            printf("\tputi\");
            break;
	case PUTC:     
            ex(p->opr.op[0],local,argument);
            printf("\tputc\");
            break;
	case PUTS:     
            ex(p->opr.op[0],local,argument);
            printf("\tputs\");
            break;
	case PUTI_:     
            ex(p->opr.op[0],local,argument);
            printf("\tputi_\");
            break;
	case PUTC_:     
            ex(p->opr.op[0],local,argument);
            printf("\tputc_\");
            break;
	case PUTS_:     
            ex(p->opr.op[0],local,argument);
            printf("\tputs_\");
            break;
        case '=':       
            ex(p->opr.op[1],local,argument);
	    char str[6];
	    reg = find(p->opr.op[0]->id.name,argument);
	    if ( reg == NULL ){
		reg = find(p->opr.op[0]->id.name,argument);
	    }
	    if(reg == NULL){
		
		sprintf(str,"fp[%d]",local->size);
	    	local = insert(p->opr.op[0]->id.name,str,local)
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
	    printf("\tRET\n");
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
 
      case typeFunc:
	paramlist* argu = p->funcNode.init;
	paramlist* param = p->funcNode.func->localval;

	char* regpos;       
	int i = 0;
	if(argu->size != param->size ){ 
	//print errors size  not equal;
	}
	for(int i =0;i<argu->size;i++){
		regpos = find(argu->name[i],local);
		if(regpos == null){
		//print error argument doesn't exists;	
		}else{
		   printf("\tpush\t%s\n",regpos);
		   char str[6];		   
		   sprintf(str,"fp[%d]",i - param->size-3);
		   argument = insert(param->name[i],str,argument);		
		}
	}	
	printf("\tcall\tL%03d,%d\n", lbl++,argu->size);
	printf("\tpush\tsp");
	printf("\tpush\t10");
	printf("\tadd\t");
	printf("\tpop\tsp");
	ex(p->funcNode.function->stmt,NULL,argument);
	argument->size = 0;
	break;       
    }
    return 0;
}

char*  find (char* name,entry* t){
   if(t == NULL) return NULL;
   for(i = 0;i<t->size;i++){
   	if(strcmp(name,t->table[i]->name) == 0)
	return t->table[i]->pos;  
  }
    return NULL;
}

entry* insert(char* name,char* regpos,entry* t){
	if(t == NULL){
	   t = (entry*)malloc(sizeof(entry));	
	}
	elem* insertone = (elem*) malloc(sizeof(elem));
	insertone->name = name;
	insertone->pos = regpos;
	t[size++]=insertone;
	return t;
}


