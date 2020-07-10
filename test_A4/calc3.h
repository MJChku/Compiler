typedef enum { typeCon, typeCon_c, typeCon_s, typeId, typeOpr, typeExpr, typeFunc, typeCall, typeScope } nodeEnum;
typedef enum { array, normal } typeEnum;
typedef enum { FP, SP, SB, FUNC } regEnum;

/* array dimension */

typedef struct arraydec {
	int dim[5];
	int size;

} arraydec;


typedef struct arraydim {
	struct nodeTypeTag* dim[5];
	int size;

} arraydim;

typedef struct symbol {
    char* name[50];
    arraydec* dim[50]; 
    int size;

}symbol;

/* constants */
typedef struct {
    int value;                  /* value of constant */
} conNodeType;

/* char constants */
typedef struct {
    char value;                  /* value of constant */
} con_cNodeType;

/* string constants */
typedef struct {
    char *value;                  /* value of constant */
} con_sNodeType;

/* identifiers */
typedef struct {
    char *i;                  /* subscript to sym array */
    arraydec* dim;
    arraydim* elem;
    int type;
    
} idNodeType;

/* operators */
typedef struct {
    int oper;                   /* operator */
    int nops;                   /* number of operands */
    struct nodeTypeTag *op[1];  /* operands (expandable) */
} oprNodeType;

/* expressions */
typedef struct {
    int noexpr;                   /* number of expressions */
    struct nodeTypeTag *exprs[1];  /* operands (expandable) */
} exprsNodeType;


/* function */
typedef struct {
    char *name;                  /* function name */ 
    struct nodeTypeTag *arg;          /* function argument list */
    struct nodeTypeTag *body;    /* function body */
} funcNodeType;

typedef struct {
    char *name;
    struct nodeTypeTag *arg;        /* function argument list */
} callNodeType;

typedef struct {
    struct nodeTypeTag *stmt;        /* statements in inner scope */
} scopeNodeType;

typedef struct nodeTypeTag {
    nodeEnum type;              /* type of node */

    /* union must be last entry in nodeType */
    /* because operNodeType may dynamically increase */
    union {
        conNodeType con;        /* constants */
        con_cNodeType con_c;        /* char constants */
        con_sNodeType con_s;        /* string constants */
        idNodeType id;          /* identifiers */
        oprNodeType opr;        /* operators */
        exprsNodeType expr;    /* expressions */
        funcNodeType func;    /* function */
        callNodeType call;  /* call function */
        scopeNodeType scope; /* scoping */
    };
} nodeType;


typedef struct {
    int jump;
    char *name;
    regEnum reg;
    int offset;
} variable;

typedef struct {
    char *name;
    int ln;
    int num_of_args;
} function;

typedef struct contextTag {
    int nvar;
    int fvar; //number of frame variables
    variable *vars;
    int nfunc;
    function *funcs;
    struct contextTag *outer;
} context;

context *global;


