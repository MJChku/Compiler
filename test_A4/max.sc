// MAX(X,Y)

max(a, b){
    if (a > b){
        return a;
    } else{
        return b;
    }
}

puts_("Enter 2 numbers: ");
geti(x);
geti(y);
z = max(x, y);
puti_(z);
puts(" is larger");