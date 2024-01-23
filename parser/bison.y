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
    logicType logicType;
}

%token<intValue> TOKEN_INT
%token<floatValue> TOKEN_FLOAT
%token<boolValue> TOKEN_BOOL
%token<stringValue> TOKEN_STRING TOKEN_NAME

%token TOKEN_OPEN TOKEN_CLOSE TOKEN_END TOKEN_SELECT TOKEN_FROM TOKEN_DELIMITER

%token<compareType> TOKEN_LEQ TOKEN_GEQ TOKEN_LESS TOKEN_GREATER TOKEN_EQ TOKEN_NEQ
%token<logicType> TOKEN_OR TOKEN_AND TOKEN_NOT
%type<node> EXP VALUE COMPARE_EXP LOGIC_EXP SELECT_EXP REFERENCE TABLE COLUMN
%type<compareType> COMPARE
%type<logicType> LOGIC

%start EXPS

%%

EXPS: | EXPS EXP {
    *tree = $2;
};

EXP:
    VALUE |
    COMPARE_EXP |
    LOGIC_EXP |
    SELECT_EXP

COMPARE:
    TOKEN_LEQ |
    TOKEN_GEQ |
    TOKEN_LESS |
    TOKEN_GREATER |
    TOKEN_EQ |
    TOKEN_NEQ

LOGIC:
    TOKEN_OR |
    TOKEN_AND |
    TOKEN_NOT

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

TABLE: TOKEN_NAME  {
    Node *node = createNode();
    node->type = NTOKEN_TABLE;
    node->data.TABLE.table = $1;
    $$ = node;
};
COLUMN: TOKEN_NAME  {
    Node *node = createNode();
    node->type = NTOKEN_COLUMN;
    node->data.COLUMN.column = $1;
    $$ = node;
};
REFERENCE: TABLE TOKEN_DELIMITER COLUMN {
    Node *node = createNode();
    node->type = NTOKEN_REFERENCE;
    node->data.REFERENCE.table = $1;
    node->data.REFERENCE.column = $3;
    $$ = node;
};
SELECT_EXP: TOKEN_SELECT REFERENCE TOKEN_FROM TABLE {
    Node *node = createNode();
    node->type = NTOKEN_SELECT;
    node->data.SELECT.reference = $2;
    node->data.SELECT.table = $4;
    $$ = node;
};

LOGIC_EXP: TOKEN_OPEN LOGIC_EXP TOKEN_CLOSE {
    $$ = $2;
} |
TOKEN_NOT EXP {
    Node *node = createNode();
    node->type = NTOKEN_LOGIC;
    node->data.LOGIC.type = $1;
    node->data.LOGIC.left = $2;
    node->data.LOGIC.right = NULL;
    $$ = node;
} |
EXP LOGIC EXP {
    Node *node = createNode();
    node->type = NTOKEN_LOGIC;
    node->data.LOGIC.type = $2;
    node->data.LOGIC.left = $1;
    node->data.LOGIC.right = $3;
    $$ = node;
}

COMPARE_EXP: TOKEN_OPEN COMPARE_EXP TOKEN_CLOSE {
    $$ = $2;
} |
EXP COMPARE EXP {
    Node *node = createNode();
    node->type = NTOKEN_COMPARE;
    node->data.COMPARE.type = $2;
    node->data.COMPARE.left = $1;
    node->data.COMPARE.right = $3;
    $$ = node;
}

%%