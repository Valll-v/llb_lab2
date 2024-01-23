#include <stdio.h>
#include <stdbool.h>

extern int yylineno;  /* Для отладки */

enum nodeType {
    NTOKEN_INT = 0,
    NTOKEN_FLOAT,
    NTOKEN_BOOL,
    NTOKEN_STRING,
    NTOKEN_COMPARE,
    NTOKEN_LOGIC,
    NTOKEN_TABLE,
    NTOKEN_COLUMN,
    NTOKEN_REFERENCE,
    NTOKEN_SELECT,
    NTOKEN_REFERENCE_LINKED_LIST,
    NTOKEN_WHERE,
    NTOKEN_QUERIES_LINKED_LIST
};  /* Типы значений */

enum compareType {
    NTOKEN_GEQ = 0,
    NTOKEN_LEQ,
    NTOKEN_LESS,
    NTOKEN_GREATER,
    NTOKEN_EQ,
    NTOKEN_NEQ
};  /* Типы сравнений */

enum logicType {
    NTOKEN_OR = 0,
    NTOKEN_AND,
    NTOKEN_NOT
};  /* Типы логических операций */

typedef enum nodeType nodeType;

typedef enum compareType compareType;

typedef enum logicType logicType;

struct Node {
    enum nodeType type;
    union {
        struct {
            struct Node *query;
            struct Node *next;
        } QUERIES_LINKED_LIST;
        struct {
            int value;
        } INT;
        struct {
            float value;
        } FLOAT;
        struct {
            bool value;
        } BOOL;
        struct {
            char *value;
        } STRING;
        struct {
            char *table;
        } TABLE;
        struct {
            char *column;
        } COLUMN;
        struct {
            compareType type;
            struct Node *left;
            struct Node *right;
        } COMPARE;
        struct {
            logicType type;
            struct Node *left;
            struct Node *right;
        } LOGIC;
        struct {
            struct Node *reference;
            struct Node *next;
        } REFERENCE_LINKED_LIST;
        struct {
            struct Node *table;
            struct Node *column;
        } REFERENCE;
        struct {
            struct Node *reference;
            struct Node *table;
            struct Node *where;
        } SELECT;
        struct {
            struct Node *logic;
        } WHERE;
    } data;
};  /* Будем преобразовывать наш код в AST */

typedef struct Node Node;

extern int yyparse(Node **result);

extern FILE *yyin;

void yyerror();

Node *parseQuery(FILE *f);

Node* createNode();

void freeNode(Node *node);

const char * getTypeCompare(compareType);

const char * getTypeLogic(logicType);

void printTree(Node *tree, int tab);
