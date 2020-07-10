

puts("tower of  hanoi: ");
puts("input size of tower");
geti(a);

tower_h("A","B","C",a);


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

