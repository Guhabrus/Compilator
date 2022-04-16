%option nounput
%option noinput
%option noyywrap

%{



static void input_token(const char * tokName)
{
    printf("%s, ""%s"" \n", tokName, yytext);
}


%}


INTEGER [0-9]+
IDENTIFIER[a-z_0-9]+
FILE[a-zA-Z"."txt]+


  

%%
[T]          {input_token("TRUE");    }  
[F]          {input_token("FALSE");   } 

{INTEGER}    {input_token("ERROR");   }
 
[(]          {input_token("LPARENT"); }
[)]          {input_token("RPARENT"); }
[&,|]{3,}*   {input_token("ERROR");   }  
 
[&]{2}*      {input_token("LAND");    }
[|]{2}*      {input_token("LOR");     }

[!]          {input_token("LNOT");    } 

[=]          {input_token("ASIGN");   } 
[{]          {input_token("LFPARENT");}    
[}]          {input_token("RFPARENT");}    
[","]        {input_token("COMMA");}       
["\n"]       {} 
["\t"]       {}
[" "]        {}



{IDENTIFIER} {input_token("IDENTIFIER"); }  

. {input_token("ERROR");}





%%  

#include "lexer.h"

int main(int argc, char **argv)
{
   
    FILE *test_file = fopen(argv[1], "r");
    
    if (test_file != NULL)
    {
        yyrestart(test_file);
        
    }
    int res = yylex();
    
    return 0;
}