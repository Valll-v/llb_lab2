%{
    #include <stdio.h>
    #include "tree.h"
    extern int yylex();
%}

%parse-param {Node **tree}

%union {
    Node *node;
	int ivalue;
}

%token<ivalue> TOKEN_NUM
%token TOKEN_PLUS TOKEN_MINUS TOKEN_MULTIPLY
%type<node> exp
%start exps

%%

exps: | exps exp {
    *tree = $2;
};

exp: TOKEN_NUM {
    Node *node = createNode();
    node->type = NTOKEN_INT;
    node->data.INT.value = $1;
    $$ = node;
} |
exp TOKEN_PLUS exp {
    Node *node = createNode();
    node->type = NTOKEN_PLUS;
    node->data.PLUS.left = $1;
    node->data.PLUS.right = $3;
    $$ = node;
} |
exp TOKEN_MINUS exp	{
    Node *node = createNode();
    node->type = NTOKEN_MINUS;
    node->data.MINUS.left = $1;
    node->data.MINUS.right = $3;
    $$ = node;
} |
exp TOKEN_MULTIPLY exp {
    Node *node = createNode();
    node->type = NTOKEN_MULTIPLY;
    node->data.MULTIPLY.left = $1;
    node->data.MULTIPLY.right = $3;
    $$ = node;
};

%%