#include <stdio.h>

extern int yylineno;  /* Для отладки */

enum nodeType {
    NTOKEN_INT = 0,
    NTOKEN_PLUS,
    NTOKEN_MINUS,
    NTOKEN_MULTIPLY
};  /* Типы "входных данных" */

struct Node {
    enum nodeType type;
    union {
        struct {
            int value;
        } INT;
        struct {
            struct Node* left;
            struct Node* right;
        } PLUS;
        struct {
            struct Node* left;
            struct Node* right;
        } MINUS;
        struct {
            struct Node* left;
            struct Node* right;
        } MULTIPLY;
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
