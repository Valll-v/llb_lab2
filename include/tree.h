#include <stdio.h>
#include <stdbool.h>

extern int yylineno;  /* Для отладки */

enum nodeType {
    NTOKEN_INT = 0,
    NTOKEN_FLOAT,
    NTOKEN_BOOL,
    NTOKEN_STRING,
    NTOKEN_COMPARE
};  /* Типы значений */

enum compareType {
    NTOKEN_GEQ = 0,
    NTOKEN_LEQ,
    NTOKEN_LESS,
    NTOKEN_GREATER,
    NTOKEN_EQ,
    NTOKEN_NEQ
};  /* Типы сравнений */

typedef enum nodeType nodeType;

typedef enum compareType compareType;

struct Node {
    enum nodeType type;
    union {
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
            char * value;
        } STRING;
        struct {
            compareType type;
            struct Node *left;
            struct Node *right;
        } COMPARE;
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

void printTree(Node *tree, int tab);
