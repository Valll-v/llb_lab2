#include "tree.h"
#include "stdio.h"

int main(int argc, char * argv[]) {
    FILE *f = NULL;

    if (argc == 1) {
        f = stdin;
    } else {
        char* filename = argv[1];
        f = fopen(filename, "r");
        if (f == NULL) {
            printf("Can't read file: %s \n", filename);
            return -1;
        }
    }

    printf("File has been read! Enter your query, if you using stdin.\n");

    Node *tree = parseQuery(f);
    if (tree == NULL) {
        printf("tree is NULL, fault!!! \n");
    } else {
        printTree(tree, 0);
    }

    freeNode(tree);
    fclose(f);
    return 0;
}
