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

%token TOKEN_OPEN TOKEN_CLOSE TOKEN_DOT TOKEN_COMMA TOKEN_ASSIGNMENT
%token TOKEN_SELECT TOKEN_FROM TOKEN_WHERE TOKEN_CREATE TOKEN_DROP TOKEN_TABLE
%token TOKEN_DELETE TOKEN_INSERT TOKEN_INTO TOKEN_UPDATE TOKEN_SET

%token<compareType> TOKEN_LEQ TOKEN_GEQ TOKEN_LESS TOKEN_GREATER TOKEN_EQ TOKEN_NEQ
%token<logicType> TOKEN_OR TOKEN_AND TOKEN_NOT TOKEN_END
%type<node> EXP VALUE COMPARE_EXP LOGIC_EXP SELECT_EXP REFERENCE TABLE COLUMN REFERENCE_LINKED_LIST WHERE QUERY
%type<node> QUERIES_LINKED_LIST UPDATE_EXP SET_LINKED_LIST SET
%type<compareType> COMPARE
%type<logicType> LOGIC

%start QUERIES

%%

QUERIES: | QUERIES_LINKED_LIST {
    *tree = $1;
};

QUERIES_LINKED_LIST:  {
    $$ = NULL;
} | QUERY TOKEN_END QUERIES_LINKED_LIST {
    Node *node = createNode();
    node->type = NTOKEN_QUERIES_LINKED_LIST;
    node->data.QUERIES_LINKED_LIST.query = $1;
    node->data.QUERIES_LINKED_LIST.next = $3;
    $$ = node;
};

QUERY:
    SELECT_EXP |
    UPDATE_EXP

EXP:
    VALUE |
    COMPARE_EXP |
    LOGIC_EXP |
    SELECT_EXP |
    REFERENCE

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

SET: COLUMN TOKEN_ASSIGNMENT VALUE {
    Node *node = createNode();
    node->type = NTOKEN_SET;
    node->data.SET.column = $1;
    node->data.SET.value = $3;
    $$ = node;
};
SET_LINKED_LIST: SET TOKEN_COMMA SET_LINKED_LIST {
    Node *node = createNode();
    node->type = NTOKEN_SET_LINKED_LIST;
    node->data.SET_LINKED_LIST.set = $1;
    node->data.SET_LINKED_LIST.next = $3;
    $$ = node;
} |
SET {
    Node *node = createNode();
    node->type = NTOKEN_SET_LINKED_LIST;
    node->data.SET_LINKED_LIST.set = $1;
    node->data.SET_LINKED_LIST.next = NULL;
    $$ = node;
};
REFERENCE_LINKED_LIST: REFERENCE TOKEN_COMMA REFERENCE_LINKED_LIST {
    Node *node = createNode();
    node->type = NTOKEN_REFERENCE_LINKED_LIST;
    node->data.REFERENCE_LINKED_LIST.reference = $1;
    node->data.REFERENCE_LINKED_LIST.next = $3;
    $$ = node;
} |
REFERENCE {
    Node *node = createNode();
    node->type = NTOKEN_REFERENCE_LINKED_LIST;
    node->data.REFERENCE_LINKED_LIST.reference = $1;
    node->data.REFERENCE_LINKED_LIST.next = NULL;
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
REFERENCE: TABLE TOKEN_DOT COLUMN {
    Node *node = createNode();
    node->type = NTOKEN_REFERENCE;
    node->data.REFERENCE.table = $1;
    node->data.REFERENCE.column = $3;
    $$ = node;
};
SELECT_EXP: TOKEN_SELECT REFERENCE_LINKED_LIST TOKEN_FROM TABLE WHERE {
    Node *node = createNode();
    node->type = NTOKEN_SELECT;
    node->data.SELECT.reference = $2;
    node->data.SELECT.table = $4;
    node->data.SELECT.where = $5;
    $$ = node;
};
UPDATE_EXP: TOKEN_UPDATE TABLE TOKEN_SET SET_LINKED_LIST WHERE {
    Node *node = createNode();
    node->type = NTOKEN_UPDATE;
    node->data.UPDATE.set_list = $4;
    node->data.UPDATE.table = $2;
    node->data.UPDATE.where = $5;
    $$ = node;
};
WHERE: {
    $$ = NULL;
} | TOKEN_WHERE EXP {
    Node *node = createNode();
    node->type = NTOKEN_WHERE;
    node->data.WHERE.logic = $2;
    $$ = node;
};

LOGIC_EXP: TOKEN_OPEN LOGIC_EXP TOKEN_CLOSE {
    $$ = $2;
} |
TOKEN_NOT TOKEN_OPEN EXP TOKEN_CLOSE {
    Node *node = createNode();
    node->type = NTOKEN_LOGIC;
    node->data.LOGIC.type = $1;
    node->data.LOGIC.left = $3;
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