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
"="                 { return TOKEN_ASSIGNMENT; }

"("                 { return TOKEN_OPEN; }
")"                 { return TOKEN_CLOSE; }
"."                 { return TOKEN_DOT;}
","                 { return TOKEN_COMMA;}
";"                 { return TOKEN_END;}

"SELECT"            { return TOKEN_SELECT; }
"FROM"              { return TOKEN_FROM; }
"WHERE"             { return TOKEN_WHERE; }

"CREATE"            { return TOKEN_CREATE; }
"DROP"              { return TOKEN_DROP; }
"TABLE"             { return TOKEN_TABLE; }

"DELETE"            { return TOKEN_DELETE; }

"INSERT"            { return TOKEN_INSERT; }
"INTO"              { return TOKEN_INTO; }

"UPDATE"            { return TOKEN_UPDATE; }
"SET"               { return TOKEN_SET; }

"OR"                { yylval.logicType = 0; return TOKEN_OR; }
"AND"               { yylval.logicType = 1; return TOKEN_AND; }
"NOT"               { yylval.logicType = 2; return TOKEN_NOT; }

\"[a-zA-Z_][a-zA-Z0-9_]*\" { yylval.stringValue = strdup(yytext); return TOKEN_NAME; }

[ \n\t\r]	;
. { printf("Unknown symbol: %s\n", yytext); };
