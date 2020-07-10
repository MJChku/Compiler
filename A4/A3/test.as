equal1(a,b){
  return a==b;
}

equal2(a,b){
  return a==b;
}
equal4(a,b){
  return a==b;
}
equal3(a,b){
  return a==b;
}

tower_h(a,b,c,n){
   if( n == 1){
   	puts_("move");puts_(a);puts_("to");puts(c);
        return;
   }
   tower_h(a,c,b,n-1);
   puts_("move");puts_(a);puts_("to");puts(c);
   tower_h(b,a,c,n-1);
   return;
}


geti(bound);
for( a = 1 ; a < bound; a =a + 1;){
  puti(a);
  tower_h("A","B","C",a);
  puts("");
}
