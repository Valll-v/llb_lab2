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
    NTOKEN_REFERENCE_LIST,
    NTOKEN_WHERE,
    NTOKEN_SET,
    NTOKEN_SET_LIST,
    NTOKEN_QUERIES_LIST,
    NTOKEN_UPDATE,
    NTOKEN_CREATE,
    NTOKEN_FIELD_LIST,
    NTOKEN_FIELD,
    NTOKEN_DELETE,
    NTOKEN_INSERT,
    NTOKEN_VALUES_LIST,
    NTOKEN_DROP
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

enum fieldType {
    NTOKEN_INTEGER_FIELD = 0,
    NTOKEN_FLOAT_FIELD,
    NTOKEN_STRING_FIELD,
    NTOKEN_BOOL_FIELD
};

typedef enum nodeType nodeType;

typedef enum fieldType fieldType;

typedef enum compareType compareType;

typedef enum logicType logicType;

struct Node {
    enum nodeType type;
    union {
        struct {
            struct Node *query;
            struct Node *next;
        } QUERIES_LIST;

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
        } REFERENCE_LIST;
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
            struct Node *column;
            struct Node *value;
        } SET;
        struct {
            struct Node *set;
            struct Node *next;
        } SET_LIST;
        struct {
            struct Node *set_list;
            struct Node *table;
            struct Node *where;
        } UPDATE;

        struct {
            struct Node *table;
            struct Node *where;
        } DELETE;

        struct {
            struct Node *logic;
        } WHERE;

        struct {
            struct Node *column;
            fieldType type;
        } FIELD;
        struct {
            struct Node *field;
            struct Node *next;
        } FIELD_LIST;
        struct {
            struct Node *table;
            struct Node *field_list;
        } CREATE;

        struct {
            struct Node *value;
            struct Node *next;
        } VALUES_LIST;
        struct {
            struct Node *table;
            struct Node *values_list;
        } INSERT;

        struct {
            struct Node *table;
        } DROP;
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

const char * getTypeField(fieldType);

const char * getTypeLogic(logicType);

void printTree(Node *tree, int tab);
