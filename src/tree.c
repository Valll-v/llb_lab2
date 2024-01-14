#include <malloc.h>
#include <stdlib.h>
#include "tree.h"

#define INDENT "  "

Node* createNode() {
    Node* node = malloc(sizeof(Node));
    if (node == NULL) {
        return NULL;
    }
    *node = (Node) {0};
    return node;
}

const char * getTypeCompare(compareType type) {
    switch (type) {
        case NTOKEN_LEQ:
            return "LEQ";
        case NTOKEN_GEQ:
            return "GEQ";
        case NTOKEN_LESS:
            return "LESS";
        case NTOKEN_GREATER:
            return "GREATER";
        case NTOKEN_EQ:
            return "EQ";
        case NTOKEN_NEQ:
            return "NEQ";
    }
}

void printTree(Node *tree, int indentCount) {
    for (int i = 0; i < indentCount; i++) {
        printf(INDENT);
    }
    switch (tree->type) {
        case NTOKEN_INT:
            printf("INT(%d)\n", tree->data.INT.value);
            break;
        case NTOKEN_FLOAT:
            printf("FLOAT(%.2f)\n", tree->data.FLOAT.value);
            break;
        case NTOKEN_STRING:
            printf("STRING(%s)\n", tree->data.STRING.value);
            break;
        case NTOKEN_BOOL:
            printf("BOOL(%d)\n", tree->data.BOOL.value);
            break;
        case NTOKEN_COMPARE:
            printf("%s: \n", getTypeCompare(tree->data.COMPARE.type));
            printTree(tree->data.COMPARE.left, indentCount + 1);
            printTree(tree->data.COMPARE.right, indentCount + 1);
            break;
    }
}

void yyerror() {
    fprintf(stderr, "%d: Syntax Error.\n", yylineno);
}

void freeNode(Node *node) {
    if (node == NULL) {
        return;
    }
    free(node);
}

Node *parseQuery(FILE *f) {
    yyin = f;
    Node *nodeRef = NULL;
    yyparse(&nodeRef);
    return nodeRef;
}


