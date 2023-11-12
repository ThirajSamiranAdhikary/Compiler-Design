/*
to create AST first need to convert grammer into postfix notation.
using that converted grammer chreate abstract tree.
*/

#include <stdio.h>

char stack[50];
int top = -1;

void push(char x)
{
    stack[top++] = x;
}

char pop()
{
    if (top == -1)
    {
        return -1;
    }
    else
    {
        return stack[top--];
    }
}

int priority(char x)
{
    if (x == '(')
    {
        return 0;
    }
    if (x == '+' || x == '-')
    {
        return 1;
    }
    if (x == '*' || x == '/')
    {
        return 2;
    }
}

char postfixconvert()
{
    char exp[100];
    char postfix[100];
    char *e;
    char x;
    int y = 0;
    e = exp;

    while (*e != '\0')
    {
        if (isalnum(*e))
        {
            postfix[y] = *e;
            ++y;
        }
        else if (*e == '(')
        {
            push('(');
        }
        else if (*e == ')')
        {
            while (((x = pop()) != '('))
            {
                postfix[y] = *e;
                ++y;
            }
        }
        else
        {
            while (priority(stack[top] >= priority(*e)))
            {
                postfix[y] = pop();
                ++y;
            }
            push(*e);
        }

        ++e;
    }
    while (top != -1)
    {
        postfix[y] = pop();
    }
}

int main()
{
    return -1;
}