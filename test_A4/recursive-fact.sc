// RECURSIVE-FACTORIAL(x)
  
rfact(x, r){
    if (x <= 1){
        return r;
    } else{
        return rfact(x-1, r * x);
    }
}  
  
geti(x);
if (x == 0){
    puti(1);
} else {
    if (x >= 1 && x <= 12) {
        puti(rfact(x, 1));
    }
}
