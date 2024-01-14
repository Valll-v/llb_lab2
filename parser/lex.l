%option noyywrap
%option yylineno

%{
    #include <stdio.h>
    #include "tree.h"
    #include "bison.h"
%}

%%

[0-9]+              {yylval.intValue = atoi(yytext); return TOKEN_INT;}
[0-9]+.[0-9]+       {yylval.floatValue = atof(yytext); return TOKEN_FLOAT;}
\'(.+)\'		    {yylval.stringValue = strdup(yytext); return TOKEN_STRING;}
"false"		        {yylval.boolValue = 0; return TOKEN_BOOL;}
"true"		        {yylval.boolValue = 1; return TOKEN_BOOL;}

"<="                { return TOKEN_LEQ; }
">="                { return TOKEN_GEQ; }
"<"                 { return TOKEN_LESS; }
">"                 { return TOKEN_GREATER; }
"=="                { return TOKEN_EQ; }
"!="                { return TOKEN_NEQ; }


[a-zA-Z_][a-zA-Z0-9_]* { /* обработка идентификаторов */ }

[ \n\t\r]	;
. { printf("Unknown symbol: %s\n", yytext); };
