#include <string.h>
#include <stdlib.h>
#include <stdio.h>

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

char* cancf(char* a, char*b){
  char* news = malloc(sizeof(char)*(strlen(a)+strlen(b)+2));  
  strcat(news,a);strcat(news,b);
  return news;
}

char* canc4(char* a, int length){
  char* news = malloc(sizeof(char)*(strlen(a)+1));
  char str[2];
  strcat(news, a); sprintf(str,"%d",length+1);strcat(news,str);
  return news;
}

char* canc3(char* a, char* b){
  char* news = malloc(sizeof(char)*(strlen(a)+strlen(b)));  
  if(strcmp(a, "up") == 0){
    strcat(news,"^");strcat(news,b);
    return news;
  } 
  
  if(strcmp(a, "down") == 0){
    strcat(news,"_");strcat(news,b);
    return news;
  } 
}

char* canc2(char* a, char* b, char* c, char* dummy){
  char* news = malloc(sizeof(char)*(strlen(a)+strlen(b)+strlen(c)));
  strcat(news, a);strcat(news,b);strcat(news, c);
  return news;
}

char* canc(char* a, char* b, char* c){
  char* news;
  if(strcmp(c,"exclaim") == 0){
    news = malloc(sizeof(char)*(strlen(a)+strlen(b)+4));  
    strcat(news, a); strcat(news, "/"); strcat(news,b); strcat(news, "/");
    return news;
  }
  if ( strcmp(c,"gt") == 0){
    news = malloc(sizeof(char)*(strlen(a)+strlen(b)+8));
    strcat(news, a); strcat(news, "3/4"); strcat(news,b); strcat(news, "1/4");
    return news;
  } 
  if ( strcmp(c,"lt") == 0){
    news = malloc(sizeof(char)*(strlen(a)+strlen(b)+8));
    strcat(news, a); strcat(news, "1/4"); strcat(news,b); strcat(news, "3/4");
    return news;
  }
}

char* s2ABC(char const* c){
  
  char *ABCnote = malloc(sizeof(char)*2);
  char charc = c[0];  
switch(charc){
    case '0':
      ABCnote = "z";
      return ABCnote;
    case 'd': 
      ABCnote = "G,";
      return ABCnote;  
    case 'r': 
      ABCnote = "A,";
      return ABCnote;  
    case 'm': 
      ABCnote = "B,";
      return ABCnote;
    case 'f':
       ABCnote = "C";
       return ABCnote;  
    case 's':
       ABCnote = "D";
       return ABCnote;  
    case 'l':
       ABCnote = "E";
       return ABCnote;  
    case 't':
       ABCnote = "F";
       return ABCnote;  
    case 'D':
       ABCnote = "G";
       return ABCnote;  
    case 'R':
       ABCnote = "A";
       return ABCnote;  
    case 'M':
       ABCnote = "B";
       return ABCnote;  
    case 'F':
       ABCnote = "c";
       return ABCnote;  
    case 'S':
       ABCnote = "d";
       return ABCnote;  
    case 'L':
       ABCnote = "e";
       return ABCnote;  
    case 'T':
       ABCnote = "f";
       return ABCnote;  
}
}
