%option noyywrap yylineno



%{

#include "include/gramer.h"

void yyerror (char *);  
static void input_token(const char * tokName)
{
    //printf("%s, ""%s"" \n", tokName, yytext);
}

int count;
%}



IDENTIFIER[a-z_0-9]+



  

%%
[T]          {count += yyleng; input_token("TRUE"); return T;   }  
[F]          {count += yyleng; input_token("FALSE"); return F;   } 


 
[(]          {count += yyleng; return LPARENT; }
[)]          {count += yyleng; return RPARENT; }
[&,|]{3,}*   {input_token("ERROR");   }  
 
[&]{2}*      {count+=yyleng; return LOGIC_AND;    }
[|]{2}*      {count+=yyleng; return LOGIC_OR;     }

[!]          {count+=yyleng; return LOGIC_NOT;    } 

[=]          {count+=yyleng; return ASSIGN;   } 
[{]          {input_token("ERROR"); }    
[}]          {input_token("ERROR"); }    
[","]        {input_token("ERROR"); }       
["\n"]       {count+=yyleng; return ENTER; } 
["\t"]       {input_token("ERROR"); }
[" "]        {}



{IDENTIFIER} {count+=yyleng;return IDENTIFIER; }  

. {input_token("ERROR");}





%%  

