%{
void yyerror(char *s);
int yylex();
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
int symbols[52];    // because only one character can be used as variable
int symbol_value(char symbol);
void updatesymbol(char symbol, int val);
%}
%union{int num; char id;}
%start line
%token print_cmd;
%token exit_cmd;
%token <num> number;
%token <id> identifier
%type <num> line exp term
%type <id> assignment
%%
// description section
line    : assignment ';'            {;}
            | exit_cmd ';'          {exit(EXIT_SUCCESS);}
            | print_cmd exp ';'     {printf("Printing %d\n", $2);}
            | line assignment ';'   {;}
            | line print_cmd exp ';'{printf("Printing %d\n", $3);}
            | line exit_cmd ';'     {exit(EXIT_SUCCESS);}
        ;
assignment : identifier '=' exp     {updatesymbol($1, $3);}
            ;
exp        : term                   {$$ = $1;}
            |exp '+' term           {$$ = $1 + $3;}
            |exp '-' term           {$$ = $1 - $3;}
            ;
term       : number                 {$$ = $1;}
                    | identifier            {$$ = symbol_value($1);}
            ;
%%
// C Code section
// implementing the two called functions and the main function
int computeindex(char token)
{
    int id = -1;
    if(islower(token))
    {
            id = token - 'a' +26;
    }
    else if(isupper(token))
    {
        id = token - 'A';
    }
    return id;
}
int symbol_value(char symbol)
{
    int value = computeindex(symbol);
    return symbols[value];
}
void updatesymbol(char symbol, int val)
{
    int value = computeindex(symbol);
    symbols[value] = val;
}

int main(void)
{
    int i;
    for(i=0; i<52; i++)
    {
        symbols[i] = 0;
    }
    return yyparse();
}

void yyerror(char *s) {fprintf(stderr, "%s\n",s);}