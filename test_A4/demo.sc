

a = 1;                  //global a

gfunc(x){               //global function "gfunc"
    a = x + a;          //a is unbound, refer to the global a
}

{
    z = 2;              //local z
}

main(){                 //global function "main"
    x = 1;              //local x
    y = 2;              //local y
    gfunc(x);           //value of global a is changed
    lfunc(x){           //
        x = y + 1;      //x is bound, refer to the argument x
        return x * x;   //y is unbound, refer to the local y
    }
    puti(x);            //x is still 1
    y = lfunc(x);       //y is now 9
    puti(x);            //x is still 1
    puti(y);            //y is 9
}

main();

//lfunc(a);               //ERROR: "lfunc" is no longer alive here
//puti(z);                //ERROR: "z" is no longer alive here