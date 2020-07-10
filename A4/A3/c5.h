typedef enum { typeCon, typeId, typeOpr, typeFunc} nodeEnum;
typedef enum {integer,string,charac} typeEnum;
/* constants */
typedef struct {
	union{
         int value;                  /* value of constant */
	 char* cValue;
       };
    
} conNodeType;


typedef struct {
   char name[12];                      /* subscript to sym array */
} idNodeType;


/* operators */
typedef struct {
    int oper;                   /* operator */
    int nops;                   /* number of operands */
    struct nodeTypeTag *op[1];  /* operands (expandable) */
} oprNodeType;


typedef struct {
	struct nodeTypeTag* name[10];
	int size;
} paramlist;



typedef struct {
   char name[12];
   struct nodeTypeTag* stmt;
   paramlist* localval;
} function;

typedef struct{
   function* func;
   paramlist* init;
}funcNodeType;


typedef struct nodeTypeTag {
    nodeEnum type;              /* type of node */
    /* union must be last entry in nodeType */
    /* because operNodeType may dynamically increase */
    union {
        conNodeType con;        /* constants */
        idNodeType id;          /* identifiers */
        oprNodeType opr;        /* operators */
	funcNodeType funcNode;    
	};
} nodeType;

//


//extern int sym[26];



