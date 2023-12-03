%{
#include <stdlib.h>
#include "calc3.h"
#include "y.tab.h"
void yyerror(char *);
int lineNum=0;

%}

%option yylineno   /* creates scanner to store line number */

digit	 [0-9]
letter 	 [a-zA-Z]
nonzero	 [1-9]

alphanum {letter}|{digit}|_
fraction  .{digit}|.0
id    {letter}+{alphanum}* 
intLit {nonzero}{digit}*|0
floatLit {nonzero}{fraction}*


%%


{id}    { 
                strcpy(yylval.ndOb.name,(yytext));
                yylval.sValue = yytext;
                return VARIABLE;
            }

0           {
                strcpy(yylval.ndOb.name,(yytext));
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

{intLit} {      strcpy(yylval.ndOb.name,(yytext));
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }
            

{floatLit} {    strcpy(yylval.ndOb.name,(yytext));
                yylval.dValue = atoi(yytext);
                return 	DOUBLE;
            }

"//"[a-zA-Z0-9 \t]+                { ; }      /* ignore Inline comments */
"/*"[ \t\n]*[a-zA-Z0-9 \t\n]+"*/"   {;}       /* ignore Block comments */
            
            
[();{}.:,[]=] { return yytext[0]; }
    

             

"attribte" 	{strcpy(yylval.ndOb.name,(yytext)); return ATTRIBUTE;}
"class"		{strcpy(yylval.ndOb.name,(yytext)); return CLASS;}
"constructor" 	{strcpy(yylval.ndOb.name,(yytext)); return CONSTRUCTOR;}
"else" 		{strcpy(yylval.ndOb.name,(yytext)); return ELSE;}
"float" 	{strcpy(yylval.ndOb.name,(yytext)); return FLOAT;}
"function"	 {strcpy(yylval.ndOb.name,(yytext)); return FUNCTION;}	
"if" 		{strcpy(yylval.ndOb.name,(yytext)); return IF;}	
"integer" 	{strcpy(yylval.ndOb.name,(yytext)); return INTEGER;}	
"isa" 		{strcpy(yylval.ndOb.name,(yytext)); return ISA;}	
"localvar" 	{strcpy(yylval.ndOb.name,(yytext)); return LOCALVAR;}	
"private" 	{strcpy(yylval.ndOb.name,(yytext)); return PRIVATE;}	
"public"	{strcpy(yylval.ndOb.name,(yytext)); return PUBLIC;}
"read"		{strcpy(yylval.ndOb.name,(yytext)); return READ;}	
"return"	{strcpy(yylval.ndOb.name,(yytext)); return RETURN;}	
"self"		{strcpy(yylval.ndOb.name,(yytext)); return SELF;}	
"then"		{strcpy(yylval.ndOb.name,(yytext)); return THEN;}	
"void"		{strcpy(yylval.ndOb.name,(yytext)); return VOID;}	
"while"		{strcpy(yylval.ndOb.name,(yytext)); return WHILE;}	
"write"		{strcpy(yylval.ndOb.name,(yytext)); return WRITE;}	
"arrow"		{strcpy(yylval.ndOb.name,(yytext));return ARROW;}	



"+"	    		{strcpy(yylval.ndOb.name,(yytext)); return ADDOP;}
"-"				{strcpy(yylval.ndOb.name,(yytext)); return MINOP;}
"*"				{strcpy(yylval.ndOb.name,(yytext)); return MULOP;}
"/"				{strcpy(yylval.ndOb.name,(yytext)); return DIVOP;}
"and"			{strcpy(yylval.ndOb.name,(yytext)); return AND;}
"or"			{strcpy(yylval.ndOb.name,(yytext)); return OR;}
"not"			{strcpy(yylval.ndOb.name,(yytext)); return NOT;}
"=="		    {strcpy(yylval.ndOb.name,(yytext)); return EQOP;}
"<="			{strcpy(yylval.ndOb.name,(yytext)); return LE;}
">="   			{strcpy(yylval.ndOb.name,(yytext)); return GE;}
">" {strcpy(yylval.ndOb.name,(yytext)); return GT;}
"<" {strcpy(yylval.ndOb.name,(yytext)); return LT;}
"!=" {strcpy(yylval.ndOb.name,(yytext)); return NEQ;}


[\n]     { lineNum++;}        /* ignore whitespace  and increase line number*/
[\t]        {;}


%%
int yywrap(void) {
    return 1;
}
