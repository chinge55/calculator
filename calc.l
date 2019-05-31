%{
    /*C Declarations portion*/
    #include "y.tab.h"  // include the header file generated
    void yyerror(char *s); // for error
    int yylex(); // main entry point for lex  
%}
%%
"exit"      {return exit_cmd;}
"print"     {return print_cmd;}
[a-zA-Z]    {yylval.id = yytext[0]; return identifier;}
[0-9]+      {yylval.num = atoi(yytext); return number;}
[ \t\n]     ;
[-+=;]      {return yytext[0];}
.           {yyerror("ERROR");}
%%
int yywrap(void) {return 1;} // function called when the end of file is reached

