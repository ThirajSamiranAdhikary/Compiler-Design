%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include"lex.yy.c"
#include "postfix.c" /*to get postfix value of grammer */
#include "AST2.c" /* to create AST */

void yyerror(const char *s);
int yylex();
int yywrap();
void insertType(); /*insert data type into the type array */
void insertdef(); /*insert  class, function and attribute key words type into the type2 array */
void addtoSymbolTable(char);  /* creating symbol table */
int search(char* );  /* search function to check existing inside the symbol table */
int reservedWord(char c); /*compare with reserved words */
type_checking_error(char *type1, char *type2);
void check_declaration(char *c);
void check_return_type(char *value1,char *value2);
int check_types(char *type1, char *type2);
char *get_type(char *var);



/* struct to create symbol table */
struct details{
    char* id;
    char* datatype;
    char* type; 
    int lineno;

}symbolTable[100];

int count=0;  
int q;
char type[10]; /* to store type of the data */
char type2[20]; /* to store class, function and attribute key words */
extern int lineNum;
int sem_errors=0; /* get the error number */

struct node *head;
int label=0;
char buff[100];
char errors[10][100];
char reserved[22][10] = {"int", "float", "class", "function", "if", "else", "for", "public", "return", "private","read","write",
"id","eq","neq","lt","gt","leq","geq","or","and","void"}; /* reserved keywords*/
%}



%union {
    int iValue;                 /* integer value */
    double dValue;				/* double value */
 
};

%token <iValue> INTEGER
%token <dValue> DOUBLE
%token <sValue> VARIABLE

%token ATTRIBUTE CLASS CONTRUCTOR FLOAT FUNCTION INTEGER ISA LOCALVAR PRIVATE PUBLIC READ RETURN SELF THEN VOID WRITE WHILE IF PRINT
%nonassoc IFX
%nonassoc ELSE
%nonassoc EQOP NEQ


%left AND OR NOT
%left GE LE LT GT
%left ADDOP MINOP
%left MULOP DIVOP
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list



%%

prog: buildClassOrFunc ;

buildClassOrFunc : classDecl | funcDef  ; 

classDecl :  CLASS ID {reservedWord($2); addtoSymbolTable("CL"); } isaidList { visibilitymemberDeclList }';' ;
isaidList : ISA ID {reservedWord($2);} commaidList |E ;
commaidList :, ID {reservedWord($2);} commaidLis| E ;


visibilitymemberDeclList :visibility memberDeclList membervisibilityList |E ;
visibility: PUBLIC|PRIVATE|E ;

memberDeclList: type  FUNCTION ID {reservedWord($3);addtoSymbolTable("F");}: ( fParams ) arrow returnType ;
| constructor : ( fParams ) ;
memberDecl : type ATTRIBUTE ID {reservedWord($2);addtoSymbolTable("A"); } :  arraySizeList ;

memberFuncDecl : FUNCTION VARIABLE ":" ( fParams ) arrow returnType ';' | 	CONSTRUCTOR : ( fParams ) ';' ;
memberVarDecl : type ATTRIBUTE VARIABLE ":"  arraySize';' ;

funcDef :funcHead funcBody ;
funcHead : FUNCTION  [[ VARIABLE sr ]] VARIABLE ( fParams ) ARROW returnType {type_checkin_error($1,$6);} | FUNCTION VARIABLE sr CONSTRUCTOR ( fParams );
funcBody : { localVarDeclOrStmt } ;

localVarDeclOrStmtList: localVarDeclOrStmt  localVarDeclOrStmtList | ;
localVarDeclOrStmt : localVarDecl | statement ;

localVarDeclList : localVarDecl  localVarDeclList | ;
localVarDecl : type LOCALVAR ID {reservedWord($3); addtoSymbolTable("V");}":"  arraySize ';' | type LOCALVAR VARIABLE ":"  ( aParams ) ';'  ;

statementList  : statement statementList | ;
statement : assignStat ; 
| IF {addtoSymbolTable("K");} ( relExpr ) THEN {addtoSymbolTable("K");} statBlock ELSE {addtoSymbolTable("K");} statBlock ; 
| WHILE {addtoSymbolTable("K");}  ( relExpr ) statBlock ;
 | READ {addtoSymbolTable("K");} ( variable ) ;
 | WRITE {addtoSymbolTable("K");}  ( expr ) ; 
| RETURN {addtoSymbolTable("K");} ( expr ) ; 
| functionCall ;  ;


assignStat : variable assignOp expr ; {type_checkin_error($1,$3);}
statBlockList : statBlock statBlockList | ;
statBlock : { statement } | statement | ;

exprList : expr exprList | E;
expr : arithExpr  relExpr |E ;

arithExpr :term arithExprr {type_checkin_error($1,$2);};
arithExprr :addOp term arithExprr  |E ;

sign: + | – ;
term :factor termm ;
termm : multOp factor termm | E ;

factorList : factor factorList |  ;
factor : VARIABLE  | functionCall | intLtr {addtoSymbolTable("C"); } | floatLit {addtoSymbolTable("C"); } | ( arithExpr ) | NOT {addtoSymbolTable("K"); } factor | SIGN factor;

variableList :variable variableList | ;
variable : idnest VARIABLE  indice ;

functionCallList : functionCall  functionCallList |  ;
functionCall : idnest VARIABLE  ( aParams ) ;

idnestList : idnest idnestList |  ;
idnest : VARIABLE  indice'.' | id {addtoSymbolTable("V"); } ( aParams ) '.'  ;

indiceList : indice indiceList | ;
indice : [ arithExpr ] ;



returnType : type | VOID ;
type : INTEGER {insertType();}| DOUBLE {insertType();}| ID  ;


fParamsList  : fParams fParamsList | E;
fParams :  VARIABLE  ':' type arraySize fParamsTail | E;

aParamsList :aParams aParamsList | E ;
aParams : expr aParamsTail | E ; 

fParamsTailList : fParamsTail  fParamsTailList | E;
fParamsTail : ',' 	VARIABLE   ":" type  arraySize ;

arraySizeList : arraySize arraySizeList |  ;
arraySize : "[" INTEGER "]" | "[" "]"  ;

aParamsTailList :aParamsTail        aParamsTailList | E;
aParamsTail : ',' expr  ;

assignOp : = {addtoSymbolTable("OP"); };
relOp : EQOP {addtoSymbolTable("OP"); } |NEQ {addtoSymbolTable("OP"); } |GT {addtoSymbolTable("OP"); } |LT {addtoSymbolTable("OP"); }| LE {addtoSymbolTable("OP"); }| GE {addtoSymbolTable("OP"); }  ;
addOp : + {addtoSymbolTable("OP"); }| – {addtoSymbolTable("OP"); }| OR {addtoSymbolTable("OP"); };
multOp : * {addtoSymbolTable("OP"); }| / {addtoSymbolTable("OP"); } | AND {addtoSymbolTable("OP"); } ;




%%


/* error fucntion to encounter an error */
void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}


int main(void) {
    yyparse();
    /* to create AST */
    char postfixExpression[] = postfixconvert();

    TreeNode *root = buildExpressionTree(postfixExpression);

    printf("Infix expression from the expression tree: ");
    inorderTraversal(root);
    printf("\n");

    // Clean up by freeing allocated memory
    freeTree(root);
   
    return 0;
}


/* search the data already available in symbol table */
int search(char *type) {
	int i;
	for(i=count-1; i>=0; i--) {
		if(strcmp(symbol_table[i].id_name, type)==0) {
			return -1;
			break;
		}
	}
	return 0;
}

void addtoSymbolTable(char c) {
  q=search(yytext);
  if(!q) {
    if(c == 'CL' && (strcpy(type2,"CLASS")==0)) {
			symbolTable[count].id=strdup(yytext);
			symbolTable[count].datatype=strdup("N/A");
			symbolTable[count].lineno=lineNum;
			symbolTable[count].type=strdup("Class\t");
			count++;
		}
		else if(c == 'K') {
			symbolTable[count].id=strdup(yytext);
			symbolTable[count].datatype=strdup("N/A");
			symbolTable[count].lineno=countn;
			symbolTable[count].type=strdup("Keyword\t");
			count++;
		}
		
		else if(c == 'OP') {
			symbolTable[count].id=strdup(yytext);
			symbolTable[count].datatype=strdup("N/A");
			symbolTable[count].lineno=countn;
			symbolTable[count].type=strdup("Operators");
			count++;
		}
		else if(c == 'F'&& (strcpy(type2,"FUNCTION")==0)) {
			
			symbolTable[count].id=strdup(yytext);
			symbolTable[count].datatype=strdup(type);
			symbolTable[count].lineno=countn;
			symbolTable[count].type=strdup("Function");
			count++;
		}

        else if(c == 'A' && (strcpy(type2,"ATTRIBUTE")==0)) {
			
			symbolTable[count].id=strdup(yytext);
			symbolTable[count].datatype=strdup(type);
			symbolTable[count].lineno=countn;
			symbolTable[count].type=strdup("Attribute");
			count++;
		}

        else if(c == 'V' && (strcpy(type2,"LOCALVAR")==0)) {
			symbolTable[count].id=strdup(yytext);
			symbolTable[count].datatype=strdup(type);
			symbolTable[count].lineno=countn;
			symbolTable[count].type=strdup("LocalVariable");
			count++;
		}

        }
	}
  




void insertType() {
	strcpy(type, yytext);
}

void insertdef() {
	strcpy(type2, yytext);
}

/* semantic checking functions */
void check_declaration(char *c) {
    q = search(c);
    if(!q) {
        sprintf(errors[sem_errors], "Line %d: Variable \"%s\" not declared before usage!\n", countn+1, c);
		sem_errors++;
    }
}

/* to check return type with declaration */
void check_return_type(char *value1,char *value2) {
	char *main_datatype = get_type(value2);
	char *return_datatype = get_type(value1);
	if((!strcmp(main_datatype, "int") && !strcmp(return_datatype, "CONST")) || !strcmp(main_datatype, return_datatype)){
		return ;
	}
	else {
		printf(errors[sem_errors], "Line %d: Return type mismatch\n", countn+1);
		sem_errors++;
	}
}

/* to compare types of variables, functions, classes*/ 
int check_types(char *type1, char *type2){
	// declaration with no init
	if(!strcmp(type2, "null"))
		return -1;
	// both datatypes are same
	if(!strcmp(type1, type2))
		return 0;
	// both datatypes are different
	if(!strcmp(type1, "int") && !strcmp(type2, "float"))
		return 1;
	if(!strcmp(type1, "float") && !strcmp(type2, "int"))
		return 2;
	if(!strcmp(type1, "int") && !strcmp(type2, "char"))
		return 3;
	if(!strcmp(type1, "char") && !strcmp(type2, "int"))
		return 4;
	if(!strcmp(type1, "float") && !strcmp(type2, "char"))
		return 5;
	if(!strcmp(type1, "char") && !strcmp(type2, "float"))
		return 6;
}

/* give error message for type mismatching errors */
void type_checking_error(char *type1, char *type2){
    int val=check_types(type1, type2);
    if(!val==0){
         printf("%s  at %d",yyerror( "Type Error"),symbol_table[i].lineno);

    }
}

/* to get data typr from the symbol table */
char *get_type(char *var){
	for(int i=0; i<count; i++) {
		
		if(!strcmp(symbol_table[i].id_name, var)) {
			return symbol_table[i].data_type;
		}
	}
}

/* checking reserved words are taking as variable names */ 

int reservedWord(char c){
    for(int i=0;21>i;i++){
        if(!strcmp(reserved[i], c)){
            printf("%s  at %d",yyerror( "a reserved key word"),symbol_table[i].lineno);

        }
    }
    return 0;
}