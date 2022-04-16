

%{
 #include <stdio.h>
 extern FILE *yyin;
 extern int yylineno;
 extern int count;
 extern char *yytext;
 void yyerror(char *);
 int yylex();


//#define GRAMMER_DENUG

#ifdef GRAMMER_DENUG
        #define printf_debug(...) printf(__VA_ARGS__)
#else 
        #define printf_debug(...) do{}while(0);
#endif

%}


%token T F LOGIC_AND LOGIC_OR LOGIC_NOT IDENTIFIER ENTER
%left ASSIGN LPARENT RPARENT 


%%
statement: |  statement line           //левая рекурсия для цикла                                                 

        
line: ENTER| expression ENTER  {printf_debug("\tline %s\n", yytext);}


expression: LPARENT val oper expression            {printf_debug("expr code1- %s\n", yytext);}
|val RPARENT                                       {printf_debug("expr code2 - %s\n", yytext);}
|val RPARENT expression                            {printf_debug("expr code3 - %s\n", yytext);}

|val LPARENT val RPARENT                           {printf_debug("expr code4 - %s\n", yytext);}

|val oper expression                               {printf_debug("expr code5 - %s\n", yytext);}
|val                                               {printf_debug("expr code6 - %s\n", yytext);}
|LPARENT oper expression                           {printf_debug("expr code7 - %s\n", yytext);}    
|oper expression                                   {printf_debug("expr code8 - %s\n", yytext);}    







oper:ASSIGN  {printf_debug("assign code - %s\n", yytext);}
| LOGIC_AND  {printf_debug("assign code - %s\n", yytext);}
| LOGIC_OR   {printf_debug("assign code - %s\n", yytext);}
| LOGIC_NOT  {printf_debug("assign code - %s\n", yytext);}



val:IDENTIFIER  {printf_debug("val code - %s\n", yytext);}
| T             {printf_debug("val code - %s\n", yytext);}
| F             {printf_debug("val code - %s\n", yytext);}




%%


void yyerror(char *errmsg)
{
        fprintf(stderr, "%s (%d, %d): %s\n", errmsg, yylineno, count, yytext);
}

int main(int argc, char **argv)
{
       
        // if(argc !=2)
        // {
        //         fprintf(stderr, "x: ошибка: не задан входной файл\n");
        //         return -1;


        // }

        if(NULL == (yyin = fopen(argv[1], "r")))
        {
                printf("\n Невозможно открыть файл %s.\n", argv[1]);
                return -1;
        }
        count = 1;
        yylineno = 1;
        int res = yyparse();
        
        if(!res)
                printf("Succes\n");


        fclose(yyin);
        return res;
}