%option noyywrap

%{
    #include <stdio.h>
    #include "tree.h"  /* Если не добавить, то bison не видит typedef struct Node Node. Почему так, я так и не понял */
    #include "bison.h"
%}

%%

[0-9]+		{yylval.ivalue = atoi(yytext); return TOKEN_NUM;}
"+"		    {return TOKEN_PLUS;}
"-"		    {return TOKEN_MINUS;}
"*"		    {return TOKEN_MULTIPLY;}

[ \n\t]	;
. { printf("Unknown symbol: %s\n", yytext); };
