#include <stdio.h>
#include <stdbool.h>

extern int yylineno;  /* Для отладки */

enum nodeType {
    NTOKEN_INT = 0,
    NTOKEN_FLOAT,
    NTOKEN_BOOL,
    NTOKEN_STRING
};  /* Типы значений */

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
    } data;
};  /* Будем преобразовывать наш код в AST */

typedef struct Node Node;

extern int yyparse(Node **result);

extern FILE *yyin;

void yyerror();

Node *parseQuery(FILE *f);

Node* createNode();

void freeNode(Node *node);

void printTree(Node *tree, int tab);
