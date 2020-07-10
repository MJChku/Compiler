#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc3.h"
#include "y.tab.h"

static int lbl = 0;


const char *get_reg(regEnum reg){
    switch (reg){
        case FP:
            return "fp";
        case SP:
            return "sp";
        case SB:
            return "sb";
    }
}

variable *deref_var(char *name, context *cont){
    //find the variable in the given context with given name
    variable *result = NULL;
    int i;
    for (i = 0; i < cont->nvar; ++i){
        
        if (strcmp(cont->vars[i].name, name) == 0){ //variable is found
            result = &(cont->vars[i]);
            break;
        }
		//i += cont->vars[i].jump;
    }
    if (result == NULL && cont->outer != NULL){
        //variable not found in current scope
        result = deref_var(name, cont->outer);
    } 
    
    return result;
} 

function *deref_func(char *name, context *cont){
    //find the function in the given context with given name
    function *result = NULL;
    int i;
    for (i = 0; i < cont->nfunc; ++i){
        if (strcmp(cont->funcs[i].name, name) == 0){ //function is found
            result = &(cont->funcs[i]);
            break;
        }
    }    
    if (result == NULL && cont->outer != NULL){
        //function not found in current scope
        result = deref_func(name, cont->outer);
    }
    return result;
}

variable *save_var(nodeType* p, context *cont){
    int cont_size = cont->nvar;
    int cont_fsize = cont->fvar; 
    char *name = p->id.i;
    int outer_offset = 0;
    context *cont_ptr = cont;
    
    cont->nvar += 1;
    if (cont->outer != NULL){
	cont->fvar += 1;
    }
 
    cont->vars = realloc(cont->vars, cont->nvar * sizeof(variable));
    
    if (cont->vars == NULL){
        //yyerror("out of memory");
        exit(1);
    }
    while (cont_ptr->outer != NULL){
        cont_ptr = cont_ptr->outer;
        outer_offset += cont_ptr->fvar;
    }
    
    cont->vars[cont_size].name = name;
    if (cont->outer == NULL){ 
        // global variable
        cont->vars[cont_size].reg = SB;
        cont->vars[cont_size].offset = outer_offset + cont_fsize;
    } else{ 
        // local variable
        cont->vars[cont_size].reg = FP;
        cont->vars[cont_size].offset = cont_fsize;
    }

   if(p->id.type == array){
      int size = 1;
      for(int i = 0;i<p->id.dim->size;i++)
	  size *= p->id.dim->dim[i];

      size += p->id.dim->size;
     
      //cont->nvar += size;
      if (cont->outer != NULL){
	  cont->fvar += size;
      }
      cont->vars[cont_size].jump = size; 
      printf("\tpush\t%d\n",size);
      printf("\tpush\t%s\n","sp");
      printf("\tadd\t\n");
      printf("\tpop\t%s\n","sp");
      char reg[4];
      sprintf(reg,"%s",get_reg(cont->vars[cont_size].reg));
      int offset = cont->vars[cont_size].offset;
      printf("\tpush \t%s\n", reg);
      printf("\tpush \t%d\n", offset);
      printf("\tadd \t\n");
      printf("\tpop \t%s[%d]\n", reg, offset); 
      for(int i = 0; i < p->id.dim->size; i++)
      {
         printf("\tpush\t%d",p->id.dim->dim[i]);
         printf("\tpop\t%s[%d]\n",reg,offset+i+1);
      } 
       
    }else{cont->vars[cont_size].jump = 0;}

    return &(cont->vars[cont_size]);
}

void save_func(char *name, int ln, int num_of_args, context *cont){
    cont->nfunc += 1;
    cont->funcs = realloc(cont->funcs, cont->nfunc * sizeof(function));
    if (cont->funcs == NULL){
      //  yyerror("out of memory");
        exit(1);
    }
    
    cont->funcs[cont->nfunc - 1].name = name;
    cont->funcs[cont->nfunc - 1].ln = ln;
    cont->funcs[cont->nfunc - 1].num_of_args = num_of_args;
}



int ex(nodeType *p, context *cont) {
    if (!p) return 0;
    
    int lblx, lbly, lbl1, lbl2;
    variable *var;
    function *func;
    context *temp_cont, *temp_cont_inner;
    int i;

    switch(p->type) {
    case typeScope:
        temp_cont = malloc(sizeof(context));
        temp_cont->outer = cont;
        temp_cont->nvar = 0;
        temp_cont->fvar = cont->fvar;
        temp_cont->vars = NULL;
        temp_cont->nfunc = 0;
        temp_cont->funcs = NULL;
        
        ex(p->scope.stmt, temp_cont);
        if (temp_cont->fvar - cont->fvar >0){
printf("\tpush sp\n");
printf("\tpush %i\n", temp_cont->fvar - cont->fvar);
printf("\tsub\n");
printf("\tpop sp\n");
}
        free(temp_cont->vars);
        free(temp_cont);
        break;
    case typeFunc:
        
        lblx = lbl++;
        printf("\tjmp\tL%03d\n", lblx);
        save_func(p->func.name, lbl, p->func.arg->expr.noexpr, cont);
        printf("L%03d:\n", lbl++);

        temp_cont = malloc(sizeof(context));
        temp_cont->outer = cont;
        temp_cont->nvar = 0;
        temp_cont->fvar = cont->fvar;
        temp_cont->vars = NULL;
        
        for (i = 0; i < p->func.arg->expr.noexpr; ++i){
            if (p->func.arg->expr.exprs[i]->type != typeId){
             //   yyerror("Illegal function argument!");
                exit(1);
            }
            var = deref_var(p->func.arg->expr.exprs[i]->id.i, temp_cont);
            if (var == NULL){
                var = save_var(p->func.arg->expr.exprs[i], temp_cont);
            } else{
             //   yyerror("Warning: same name for function argument and global variables!");
                var = save_var(p->func.arg->expr.exprs[i], temp_cont);
            }
        }
        
        temp_cont->nfunc = 0;
        temp_cont->funcs = NULL;
        
        for (i = 0; i < temp_cont->nvar; ++i){
          temp_cont->vars[i].offset = -(temp_cont->nvar + 3 - i);
        }
        
        
        
        temp_cont_inner = malloc(sizeof(context));
        temp_cont_inner->outer = temp_cont;
        temp_cont_inner->nvar = 0;
        temp_cont_inner->fvar = 0;
        temp_cont_inner->vars = NULL;
        
        
        ex(p->func.body, temp_cont_inner);
        
        free(temp_cont_inner->vars);
        free(temp_cont_inner);  
        
        free(temp_cont->vars);
        free(temp_cont);     
 
        
        printf("\tpush\t0\n");// defensive push 0 and return in case
        printf("\tret\n");    // return is missing in function
        printf("L%03d:\n", lblx);
        break;
    case typeCall:
    
        func = deref_func(p->call.name, cont);
        
        if (func == NULL){
           // yyerror("Function name not found!");
            exit(1);
        }
        
        if (p->call.arg->expr.noexpr != func->num_of_args){
           // yyerror("Incorrect number of arguments in function call!");
            exit(1);
        }
        
        ex(p->call.arg, cont);
        
        printf("\tcall\tL%03d, %d\n", func->ln, func->num_of_args);
        break;
    case typeExpr:
        for (i = 0; i < p->expr.noexpr; ++i){
            ex(p->expr.exprs[i], cont);
        }
        break;
    case typeCon:       
        printf("\tpush\t%d\n", p->con.value); 
        break;    
    case typeCon_c:       
        switch(p->con_c.value){
          case '\a':
              printf("\tpush\t'\\a'\n");
              break;
          case '\b':
              printf("\tpush\t'\\b'\n");
              break;
          case '\f':
              printf("\tpush\t'\\f'\n");
              break;
          case '\n':
              printf("\tpush\t'\\n'\n");
              break;
          case '\r':
              printf("\tpush\t'\\r'\n");
              break;
          case '\t':
              printf("\tpush\t'\\t'\n");
              break;
          case '\v':
              printf("\tpush\t'\\v'\n");
              break;
          case '\\':
              printf("\tpush\t'\\\\'\n");
              break;
          case '\'':
              printf("\tpush\t'\\''\n");
              break;                        
          default:
              printf("\tpush\t'%c'\n", p->con_c.value); 
              break;
        }
        break;
    case typeCon_s:       
        printf("\tpush\t\"%s\"\n", p->con_s.value); 
        break;        
    case typeId:
        var = deref_var(p->id.i, cont);
        if (var == NULL){
            fprintf(stderr, "Undefined variable %s !\n", p->id.i);
            exit(1);
        }
	if (p->id.type == array ){
 		char reg[4]; sprintf(reg,"%s", get_reg(var->reg)); int offset =  var->offset;
                printf("\tpush\t%d\n",p->id.elem->size+1);
    		for(int i = 0; i < p->id.elem->size; i++){
        		//int size = 1;
                        printf("\tpush\t1");
        		for (int j = i+1; j < p->id.elem->size; j++)
			{   
			    printf("\tpush\t%s[%d]\n", reg, offset);
                            printf("\tpush\t%d",j+1);
			    printf("\tadd\t");
                            printf("\tpop\t%s","in");
			    printf("\tpush\t%s[%s]","sb","in");
			    printf("\tmul\t");
			    //size *= p->opr.op[0]->id.dim->dim[j];
			 }  
	     		//printf("\tpush\t%d",size);
			ex(p->id.elem->dim[i],cont);
                        printf("\tmul\n");
			printf("\tadd\n");
                      
    		}

	       	printf("\tpush\t%s[%d]\n", get_reg(var->reg), var->offset);
		printf("\tadd\t\n");
		printf("\tpop\t%s","in");
		printf("\tpush\t%s[%s]\n","sb","in");

        }else printf("\tpush\t%s[%d]\n", get_reg(var->reg), var->offset); 
        break;
    case typeOpr:
        switch(p->opr.oper) {
            case FOR:
                ex(p->opr.op[0], cont);
                printf("L%03d:\n", lblx = lbl++);
                ex(p->opr.op[1], cont);
                printf("\tj0\tL%03d\n", lbly = lbl++);
                ex(p->opr.op[3], cont);
                ex(p->opr.op[2], cont);
                printf("\tjmp\tL%03d\n", lblx);
                printf("L%03d:\n", lbly);
                break;
            case WHILE:
                printf("L%03d:\n", lbl1 = lbl++);
                ex(p->opr.op[0], cont);
                printf("\tj0\tL%03d\n", lbl2 = lbl++);
                ex(p->opr.op[1], cont);
                printf("\tjmp\tL%03d\n", lbl1);
                printf("L%03d:\n", lbl2);
                break;
            case IF:
                ex(p->opr.op[0], cont);
                if (p->opr.nops > 2) {
                    /* if else */
                    printf("\tj0\tL%03d\n", lbl1 = lbl++);
                    ex(p->opr.op[1], cont);
                    printf("\tjmp\tL%03d\n", lbl2 = lbl++);
                    printf("L%03d:\n", lbl1);
                    ex(p->opr.op[2], cont);
                    printf("L%03d:\n", lbl2);
                } else {
                    /* if */
                    printf("\tj0\tL%03d\n", lbl1 = lbl++);
                    ex(p->opr.op[1], cont);
                    printf("L%03d:\n", lbl1);
                }
                break;
            case GETI:
                printf("\tgeti\n");
                var = deref_var(p->opr.op[0]->id.i, cont);
                if (var == NULL){
                    //create new variable in current context
                    var = save_var(p->opr.op[0], cont);
                } else{
					printf("\tpop %s[%i]", get_reg(var->reg), var->offset);
				}
                break;
            case GETC:
                printf("\tgetc\n");
                var = deref_var(p->opr.op[0]->id.i, cont);
                if (var == NULL){
                    //create new variable in current context
                    var = save_var(p->opr.op[0], cont);
                } else{
					printf("\tpop %s[%i]", get_reg(var->reg), var->offset);
				}
                break;
            case GETS:
                printf("\tgets\n");
                var = deref_var(p->opr.op[0]->id.i, cont);
                if (var == NULL){
                    //create new variable in current context
                    var = save_var(p->opr.op[0], cont);
                } else{
					printf("\tpop %s[%i]", get_reg(var->reg), var->offset);
				}               
                break;                
            case PUTI:     
                ex(p->opr.op[0], cont);
                printf("\tputi\n");
                break;
            case PUTC:     
                ex(p->opr.op[0], cont);
                printf("\tputc\n");
                break;
            case PUTS:     
                ex(p->opr.op[0], cont);
                printf("\tputs\n");
                break;
            case PUTI_:     
                ex(p->opr.op[0], cont);
                printf("\tputi_\n");
                break;
            case PUTC_:     
                ex(p->opr.op[0], cont);
                printf("\tputc_\n");
                break;
            case PUTS_:     
                ex(p->opr.op[0], cont);
                printf("\tputs_\n");
                break;                
            case '=':     
                var = deref_var(p->opr.op[0]->id.i, cont);
                if (var == NULL){
                   
                    //create new variable in current context
                    //var = save_var(p->opr.op[0]->id.i, cont);
		     var = save_var(p->opr.op[0], cont);
                     ex(p->opr.op[1], cont);
                     // pop the position to array identifier. 
		      if(p->opr.op[0]->id.type == array){
                           int end = 1; int begin = p->opr.op[0]->id.dim->size + 1; 
                          for(int i = 0; i<p->opr.op[0]->id.dim->size;i++){
                             end *= p->opr.op[0]->id.dim->dim[i];
                          }

			  end = end + begin;
                          for(int i = begin; i < end; i++){
                             printf("\tpush\tsp[-1]");
                          }
                          printf("\n");
                          char reg[4]; sprintf(reg,"%s", get_reg(var->reg)); int offset =  var->offset;                        
			  for(int i = begin; i< end;i++) {
                             printf("\tpush\t%s[%d]", reg, offset);
                             printf("\tpush\t%d",i);
                             printf("\tadd\t");
                             printf("\tpop\tin");
                             printf("\tpop\tsb[in]\n");
                          }
                          printf("\tpop\tin\n");
			//  printf("\tpop \t%s\n", "in"); 
		      }

                } else{
		    ex(p->opr.op[1], cont);
                    //overwrite variable in outer context
		    if (p->opr.op[0]->id.type == array ){
                        char reg[4]; sprintf(reg,"%s", get_reg(var->reg)); int offset =  var->offset;
                        printf("\tpush\t%d\n",p->opr.op[0]->id.elem->size+1);
            		for(int i = 0; i < p->opr.op[0]->id.elem->size; i++){
                		//int size = 1;
                                printf("\tpush\t1");
                		for (int j = i+1; j < p->opr.op[0]->id.elem->size; j++)
				{   
				    printf("\tpush\t%s[%d]\n", reg, offset);
                                    printf("\tpush\t%d",j+1);
				    printf("\tadd\t");
                                    printf("\tpop\t%s","in");
				    printf("\tpush\t%s[%s]","sb","in");
				    printf("\tmul\t");
				    //size *= p->opr.op[0]->id.dim->dim[j];
				 }  
		     		//printf("\tpush\t%d",size);
				ex(p->opr.op[0]->id.elem->dim[i],cont);
                                printf("\tmul\n");
				printf("\tadd\n");
                              
            		}
		       	printf("\tpush\t%s[%d]\n", reg, offset);
			printf("\tadd\t\n");
			printf("\tpop\t%s","in");
			printf("\tpop\t%s[%s]\n","sb","in");
		      }else printf("\tpop \t%s[%d]\n", get_reg(var->reg), var->offset);
		   }
                break;
            case UMINUS:    
                ex(p->opr.op[0], cont);
                printf("\tneg\n");
                break;
            case RETURN:
                ex(p->opr.op[0], cont);
                printf("\tret\n");
                break;
            case DISCARD:
                ex(p->opr.op[0], cont);
                printf("\tpop \tin\n");
                break;                
            default:
                ex(p->opr.op[0], cont);
                ex(p->opr.op[1], cont);
                switch(p->opr.oper) {
                    case '+':   printf("\tadd\n"); break;
                    case '-':   printf("\tsub\n"); break; 
                    case '*':   printf("\tmul\n"); break;
                    case '/':   printf("\tdiv\n"); break;
                    case '%':   printf("\tmod\n"); break;
                    case '<':   printf("\tcomplt\n"); break;
                    case '>':   printf("\tcompgt\n"); break;
                    case GE:    printf("\tcompge\n"); break;
                    case LE:    printf("\tcomple\n"); break;
                    case NE:    printf("\tcompne\n"); break;
                    case EQ:    printf("\tcompeq\n"); break;
                    case AND:   printf("\tand\n"); break;
                    case OR:    printf("\tor\n"); break;
                }
        }
    }
    return 0;
}
