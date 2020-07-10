func(a){
   if(a == 1) {return 1;}
   return a*func(a-1);
}

puts("input an integer x and output x! ");
geti(a);
puti(func(a)); 
