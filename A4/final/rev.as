rev(){
    getc(a);
    if(a == '$'){ 
	return;}
    rev();
    putc_(a);
    return;
}

puts("input a string and mark the end with $ (a must)");
rev();
putc('$');
