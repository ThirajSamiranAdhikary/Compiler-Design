#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "postfix.c" //to get postfix value of grammer

// Structure of tree node
typedef struct TreeNode
{
    char data;
    struct TreeNode *left; // left side
    struct TreeNode *right;
} TreeNode;

// Structure to represent a stack node. stack use to set grammer in to tree.
typedef struct StackNode
{
    TreeNode *treeNode;
    struct StackNode *next;
} StackNode;

// Function to create a new tree node
TreeNode *createTreeNode(char data)
{
    TreeNode *newNode = (TreeNode *)malloc(sizeof(TreeNode));
    if (newNode == NULL)
    {
        fprintf(stderr, "Memory allocation failed.\n");
        exit(1);
    }
    newNode->data = data;
    newNode->left = newNode->right = NULL;
    return newNode;
}

// Function to create a new stack node
StackNode *createStackNode(TreeNode *treeNode)
{
    StackNode *newNode = (StackNode *)malloc(sizeof(StackNode));
    if (newNode == NULL)
    {
        fprintf(stderr, "Memory allocation failed.\n");
        exit(1);
    }
    newNode->treeNode = treeNode;
    newNode->next = NULL;
    return newNode;
}

// Function to push a tree node onto the stack
void push(StackNode **stack, TreeNode *treeNode)
{
    StackNode *newNode = createStackNode(treeNode);
    newNode->next = *stack;
    *stack = newNode;
}

// Function to pop a tree node from the stack
TreeNode *pop(StackNode **stack)
{
    if (*stack == NULL)
    {
        fprintf(stderr, "Stack is empty.\n");
        exit(1);
    }
    StackNode *top = *stack;
    *stack = top->next;
    TreeNode *treeNode = top->treeNode;
    free(top);
    return treeNode;
}

// Function to build an expression tree from a postfix expression
TreeNode *buildExpressionTree(char postfix[])
{
    StackNode *stack = NULL;
    for (size_t i = 0; i < strlen(postfix); i++)
    {
        if (isalnum(postfix[i]))
        {
            TreeNode *treeNode = createTreeNode(postfix[i]);
            push(&stack, treeNode);
        }
        else if (postfix[i] == '+' || postfix[i] == '-' || postfix[i] == '*' || postfix[i] == '/')
        {
            TreeNode *right = pop(&stack);
            TreeNode *left = pop(&stack);
            TreeNode *treeNode = createTreeNode(postfix[i]);
            treeNode->left = left;
            treeNode->right = right;
            push(&stack, treeNode);
        }
    }
    return pop(&stack);
}

// Function to perform an in-order traversal of the tree
void inorderTraversal(TreeNode *root)
{
    if (root)
    {
        if (root->left || root->right)
            printf("(");
        inorderTraversal(root->left);
        printf("%c", root->data);
        inorderTraversal(root->right);
        if (root->left || root->right)
            printf(")");
    }
}

// Function to free the memory allocated for the tree
void freeTree(TreeNode *root)
{
    if (root)
    {
        freeTree(root->left);
        freeTree(root->right);
        free(root);
    }
}

int main()
{
    char postfixExpression[] = "ab+cde+**";

    TreeNode *root = buildExpressionTree(postfixExpression);

    printf("Infix expression from the expression tree: ");
    inorderTraversal(root);
    printf("\n");

    // Clean up by freeing allocated memory
    freeTree(root);

    return 0;
}
