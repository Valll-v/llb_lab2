%{
    #include <stdio.h>
    #include <stdbool.h>
    #include "tree.h"
    extern int yylex();
%}

%parse-param {Node **tree}

%union {
    Node * node;
	int intValue;
    float floatValue;
    bool boolValue;
    char * stringValue;
    compareType compareType;
}

%token<intValue> TOKEN_INT
%token<floatValue> TOKEN_FLOAT
%token<boolValue> TOKEN_BOOL
%token<stringValue> TOKEN_STRING

%token<compareType> TOKEN_LEQ TOKEN_GEQ TOKEN_LESS TOKEN_GREATER TOKEN_EQ TOKEN_NEQ
%type<node> VALUE EXP
%type<compareType> COMPARE

%start EXPS

%%

EXPS: | EXPS EXP {
    *tree = $2;
};

COMPARE:
    TOKEN_LEQ |
    TOKEN_GEQ |
    TOKEN_LESS |
    TOKEN_GREATER |
    TOKEN_EQ |
    TOKEN_NEQ

VALUE: TOKEN_INT {
    Node *node = createNode();
    node->type = NTOKEN_INT;
    node->data.INT.value = $1;
    $$ = node;
} |
TOKEN_FLOAT {
    Node *node = createNode();
    node->type = NTOKEN_FLOAT;
    node->data.FLOAT.value = $1;
    $$ = node;
} |
TOKEN_BOOL {
    Node *node = createNode();
    node->type = NTOKEN_BOOL;
    node->data.BOOL.value = $1;
    $$ = node;
} |
TOKEN_STRING {
    Node *node = createNode();
    node->type = NTOKEN_STRING;
    node->data.STRING.value = $1;
    $$ = node;
};


EXP: VALUE COMPARE VALUE {
    Node *node = createNode();
    node->type = NTOKEN_COMPARE;
    node->data.COMPARE.type = $2;
    node->data.COMPARE.left = $1;
    node->data.COMPARE.right = $3;
    $$ = node;
}


%%