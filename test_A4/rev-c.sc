// REV-C(x)

rev(){
    getc(x);
    if (x != '\n'){
        rev();
        putc_(x);
    }
    
}

puts("Please enter a line:");
rev();
puts("");