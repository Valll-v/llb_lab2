%option noyywrap
%option yylineno

%{
    #include <stdio.h>
    #include "tree.h"
    #include "bison.h"
%}

%%

[0-9]+              { yylval.intValue = atoi(yytext); return TOKEN_INT; }
[0-9]+.[0-9]+       { yylval.floatValue = atof(yytext); return TOKEN_FLOAT; }
\'(.+)\'            { yylval.stringValue = strdup(yytext); return TOKEN_STRING; }
"false"		        { yylval.boolValue = 0; return TOKEN_BOOL; }
"true"              { yylval.boolValue = 1; return TOKEN_BOOL; }

">="                { yylval.compareType = 0; return TOKEN_GEQ; }
"<="                { yylval.compareType = 1; return TOKEN_LEQ; }
"<"                 { yylval.compareType = 2; return TOKEN_LESS; }
">"                 { yylval.compareType = 3; return TOKEN_GREATER; }
"=="                { yylval.compareType = 4; return TOKEN_EQ; }
"!="                { yylval.compareType = 5; return TOKEN_NEQ; }

"("                 { return TOKEN_OPEN; }
")"                 { return TOKEN_CLOSE; }
"."                 { return TOKEN_DELIMITER;}

"SELECT"            { return TOKEN_SELECT; }
"FROM"              { return TOKEN_FROM; }

"OR"                { yylval.logicType = 0; return TOKEN_OR; }
"AND"               { yylval.logicType = 1; return TOKEN_AND; }
"NOT"               { yylval.logicType = 2; return TOKEN_NOT; }

[a-zA-Z_][a-zA-Z0-9_]* { yylval.stringValue = strdup(yytext); return TOKEN_NAME; }

[ \n\t\r]	;
. { printf("Unknown symbol: %s\n", yytext); };
