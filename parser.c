#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// to store grammer
char grammer[][] = {};

// to store parse tree
char parsetbale[][][] = {{}, {}};

int size[][] = {
    {},
};
char s[50], stack[50];

void main()
{

    int i, j, row, col, flag = 0;

    // to print grammers
    for (i = 0; i < sizeof(grammer[][]); i++)
    {
        printf("%s\n", grammer[i])
    }

    s = yytext(); // get the user input grammer
    strcat(s, "$");
    int n = strlen(s);
    stack[0] = "$";
    stack[1] = "star_symbol";
    i = 1, j = 0;

    while (1)
    {
        if (stack[i] == s[j])
        {
            i--, j++;
            if (stack[i] == '$' && s[j] == '$')
            {
                printf("Success");
                break;
            }

            else if (stack[i] == '$' && s[j] != '$')
            {
                printf("Error");
                break;
            }
        }

        switch (stack[i])
        {
        case 'ss':
            row = 0;
            break;
        // write for all terminas
        default:
            break;
        }

        switch (s[j])
        {
        case 'terminals':
            col = 0;
            break;
        // write all the terminals
        case '$':
            col = 5;
        default:
            break;
        }

        if (parsetbale[row][col][0] == '\0')
        {
            printf("Error");
            break;
        }
else if((parsetbale[row0
    }[col][0]=='E'))
    {
    }
}
}
