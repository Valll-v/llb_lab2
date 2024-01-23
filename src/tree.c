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

const char * getTypeLogic(logicType type) {
    switch (type) {
        case NTOKEN_AND:
            return "AND";
        case NTOKEN_OR:
            return "OR";
        case NTOKEN_NOT:
            return "NOT";
    }
}


void printIndent(int indentCount) {
    for (int i = 0; i < indentCount; i++) {
        printf(INDENT);
    }
}


void printTree(Node *tree, int indentCount) {
    printIndent(indentCount);
    switch (tree->type) {
        case NTOKEN_QUERIES_LINKED_LIST:
            printf("QUERIES:\n");
            printTree(tree->data.QUERIES_LINKED_LIST.query, indentCount + 1);
            while (tree->data.QUERIES_LINKED_LIST.next != NULL) {
                tree = tree->data.QUERIES_LINKED_LIST.next;
                printTree(tree->data.QUERIES_LINKED_LIST.query, indentCount + 1);
            }
            break;
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
        case NTOKEN_LOGIC:
            printf("%s: \n", getTypeLogic(tree->data.LOGIC.type));
            printTree(tree->data.LOGIC.left, indentCount + 1);
            if (tree->data.LOGIC.type != NTOKEN_NOT) {
                printTree(tree->data.COMPARE.right, indentCount + 1);
            }
            break;
        case NTOKEN_TABLE:
            printf("TABLE(%s)\n", tree->data.TABLE.table);
            break;
        case NTOKEN_COLUMN:
            printf("COLUMN(%s)\n", tree->data.COLUMN.column);
            break;
        case NTOKEN_REFERENCE_LINKED_LIST:
            printf("TABLE_REFERENCES:\n");
            printTree(tree->data.REFERENCE_LINKED_LIST.reference, indentCount + 1);
            while (tree->data.REFERENCE_LINKED_LIST.next != NULL) {
                tree = tree->data.REFERENCE_LINKED_LIST.next;
                printTree(tree->data.REFERENCE_LINKED_LIST.reference, indentCount + 1);
            }
            break;
        case NTOKEN_REFERENCE:
            printf("TABLE_REFERENCE:\n");
            printTree(tree->data.REFERENCE.table, indentCount + 1);
            printTree(tree->data.REFERENCE.column, indentCount + 1);
            break;
        case NTOKEN_SELECT:
            printf("SELECT\n");
            printTree(tree->data.SELECT.reference, indentCount + 1);
            printIndent(indentCount);
            printf("FROM\n");
            printTree(tree->data.SELECT.table, indentCount + 1);
            printIndent(indentCount);
            if (tree->data.SELECT.where != NULL) {
                printf("WHERE\n");
                printTree(tree->data.SELECT.where->data.WHERE.logic, indentCount + 1);
            }
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


