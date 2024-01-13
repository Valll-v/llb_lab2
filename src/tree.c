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

void printTree(Node *tree, int indentCount) {
    for (int i = 0; i < indentCount; i++) {
        printf(INDENT);
    }
    switch (tree->type) {
        case NTOKEN_INT:
            printf("NUM(%d)\n", tree->data.INT.value);
            break;
        case NTOKEN_PLUS:
            printf("PLUS:\n");
            printTree(tree->data.PLUS.left, indentCount + 1);
            printTree(tree->data.PLUS.right, indentCount + 1);
            break;
        case NTOKEN_MINUS:
            printf("MINUS:\n");
            printTree(tree->data.MINUS.left, indentCount + 1);
            printTree(tree->data.MINUS.right, indentCount + 1);
            break;
        case NTOKEN_MULTIPLY:
            printf("MULTIPLY:\n");
            printTree(tree->data.MULTIPLY.left, indentCount + 1);
            printTree(tree->data.MULTIPLY.right, indentCount + 1);
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
    switch (node->type) {
        case NTOKEN_INT:
            break;
        case NTOKEN_PLUS:
            freeNode(node->data.PLUS.right);
            freeNode(node->data.PLUS.left);
            break;
        case NTOKEN_MINUS:
            freeNode(node->data.MINUS.right);
            freeNode(node->data.MINUS.left);
            break;
        case NTOKEN_MULTIPLY:
            freeNode(node->data.MULTIPLY.right);
            freeNode(node->data.MULTIPLY.left);
            break;
    }
    free(node);
}

Node *parseQuery(FILE *f) {
    yyin = f;
    Node *nodeRef = NULL;
    yyparse(&nodeRef);
    return nodeRef;
}


