

%{
 #include <stdio.h>
 extern FILE *yyin;
 extern int yylineno;
 extern int count;
 extern char *yytext;
 void yyerror(char *);
 int yylex();
%}


%token T F LOGIC_AND LOGIC_OR LOGIC_NOT IDENTIFIER ENTER
%left ASSIGN LPARENT RPARENT 


%%
statement: expression statement
|%empty; 
        

expression: val                      {printf("expr code - %d\n", *yytext);}
|LPARENT val RPARENT                 {printf("expr code - %d\n", *yytext);}
|ENTER                               {printf("\n");}
|LOGIC_NOT val                       {printf("expr code - %d\n", *yytext);}
|LPARENT expression RPARENT          {printf("expr code - %d\n", *yytext);}
|expression oper val                 {printf("expr code - %d\n", *yytext);}
|LPARENT expression oper val RPARENT {printf("expr code - %d\n", *yytext);}
;





oper:ASSIGN  {printf("assign code - %d\n", *yytext);}
| LOGIC_AND  {printf("assign code - %d\n", *yytext);}
| LOGIC_OR   {printf("assign code - %d\n", *yytext);}
| LOGIC_NOT  {printf("assign code - %d\n", *yytext);}



val:IDENTIFIER  {printf("val code - %d\n", *yytext);}
| T             {printf("val code - %d\n", *yytext);}
| F             {printf("val code - %d\n", *yytext);}




%%


void yyerror(char *errmsg)
{
        fprintf(stderr, "%s (%d, %d): %s\n", errmsg, yylineno, count, yytext);
}

int main(int argc, char **argv)
{
       
        // if(argc !=2)
        // {
                // fprintf(stderr, "x: ошибка: не задан входной файл\n");
                // return -1;


        // }

        if(NULL == (yyin = fopen(argv[1], "r")))
        {
                // printf("\n Невозможно открыть файл %s.\n", argv[1]);
                // return -1;
        }
        count = 1;
        yylineno = 1;
        int res = yyparse();

        fclose(yyin);
        return res;
}