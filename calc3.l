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
                yylval.sValue = yytext;
                return VARIABLE;
            }

0           {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

{intLit} {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }
            

{floatLit} {
                yylval.dValue = atoi(yytext);
                return 	DOUBLE;
            }

"//"[a-zA-Z0-9 \t]+                { ; }      /* ignore Inline comments */
"/*"[ \t\n]*[a-zA-Z0-9 \t\n]+"*/"   {;}       /* ignore Block comments */
            
            
[();{}.:,[]=] { return yytext[0]; }
    

             

"attribte" 	{return ATTRIBUTE;}
"class"		{return CLASS;}
"constructor" 	{return CONSTRUCTOR;}
"else" 		{return ELSE;}
"float" 	{return FLOAT;}
"function"	 {return FUNCTION;}	
"if" 		{return IF;}	
"integer" 	{return INTEGER;}	
"isa" 		{return ISA;}	
"localvar" 	{return LOCALVAR;}	
"private" 	{return PRIVATE;}	
"public"	{return PUBLIC;}
"read"		{return READ;}	
"return"	{return RETURN;}	
"self"		{return SELF;}	
"then"		{return THEN;}	
"void"		{return VOID;}	
"while"		{return WHILE;}	
"write"		{return WRITE;}	
"arrow"		{return ARROW;}	



"+"	    		{return ADDOP;}
"-"				{return MINOP;}
"*"				{return MULOP;}
"/"				{return DIVOP;}
"and"			{return AND;}
"or"			{return OR;}
"not"			{return NOT;}
"=="		{return EQOP;}
"<="			{return LE;}
">="   			{return GE;}
">" {return GT;}
"<" {return LT;}
"!=" {return NEQ;}


[\n]     { lineNum++;}        /* ignore whitespace  and increase line number*/
[\t]        {;}


%%
int yywrap(void) {
    return 1;
}
