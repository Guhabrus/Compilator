

%{
 #include <stdio.h>
 #include <stdlib.h>
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

enum TYPE_NODE
{
        STATEMENT_NODE = 0,
        LOGIC_OR_NODE,
        LOGIC_AND_NODE,
        ASSIGN_NODE,
        LOGIC_NOT_NODE,
        FUNCTION_NODE
};

struct name
{
	char *type_s;
        char *arg_1;
};

//ща будем реализовывать двусвязный список (((


typedef struct B_Node
{
        int type;
        struct B_Node *parent_node;
        struct B_Node * next_node;
        
        struct B_Node *arg1;
        struct B_Node *arg2;
}Node;


typedef struct list_syntax
{
        size_t size;
        Node *head;
        Node *tail;
}vector;

 vector* list_syntax_init();
 void push_front(vector *list, int type_var);
 void pushBack(vector *list, int type_var);
 void print_all(vector *list);
 void clear_list(vector *list);
 Node* getNode(vector *list, size_t indx);

 vector *sintax_list;

 struct name arr_type[FUNCTION_NODE+1];

%}


%token T F LOGIC_AND LOGIC_OR LOGIC_NOT IDENTIFIER ENTER
%left ASSIGN LPARENT RPARENT 


%%
statement: |  statement line {  }          //левая рекурсия для цикла                                                 

        
line: ENTER| expression ENTER  {printf_debug("\tline %s\n", yytext);push_front(sintax_list, STATEMENT_NODE);print_all(sintax_list); clear_list(sintax_list);}


expression: LPARENT val oper expression            {printf_debug("expr code1- %s\n", yytext);}
|val RPARENT                                       {printf_debug("expr code2 - %s\n", yytext);}
|val RPARENT expression                            {printf_debug("expr code3 - %s\n", yytext);}

|val LPARENT val RPARENT                           {printf_debug("expr code4 - %s\n", yytext); 
                                                                                push_front(sintax_list, FUNCTION_NODE);}

|val oper expression                               {printf_debug("expr code5 - %s\n", yytext);}
|val                                               {printf_debug("expr code6 - %s\n", yytext);}
|LPARENT oper expression                           {printf_debug("expr code7 - %s\n", yytext);}    
|oper expression                                   {printf_debug("expr code8 - %s\n", yytext);}    







oper:ASSIGN  {printf_debug("assign code - %s\n", yytext); 
                                        push_front(sintax_list, ASSIGN_NODE);}

| LOGIC_AND  {printf_debug("assign code - %s\n", yytext);
                                        push_front(sintax_list, LOGIC_AND_NODE);}

| LOGIC_OR   {printf_debug("assign code - %s\n", yytext);
                                        push_front(sintax_list, LOGIC_OR_NODE);}

| LOGIC_NOT  {printf_debug("assign code - %s\n", yytext);
                                        push_front(sintax_list, LOGIC_NOT_NODE);}



val:IDENTIFIER  {printf_debug("val code1 - %s\n", yytext);}
| T             {printf_debug("val code2 - %s\n", yytext);}
| F             {printf_debug("val code3 - %s\n", yytext);}




%%
/**
 * @brief Функция инициализации двусвязного списка
 * 
 */
vector* list_syntax_init()
{
      vector *tmp =  (vector*)malloc(sizeof(vector));
      tmp->size=0;
      tmp->head = tmp->tail = NULL;
}

/**
 * @brief Функция добалвения в начало списка
 * 
 * @param list весть список куда добавлять, 
 * @param type_var тип выражения 
 */
void push_front(vector *list, int type_var)
{
        Node *tmp = (Node*)malloc(sizeof(Node));
        if(NULL==tmp)
                exit(1);

        tmp->type               = type_var;
        tmp->next_node          = list->head;
        tmp->parent_node        = NULL;
        if(list->head)
        {
                list->head->parent_node = tmp;
        }

        list->head = tmp;

        if(NULL == list->tail)
                list->tail = tmp;
        list->size++;
}       

/**
 * @brief Функция добалвения в конец списка
 * 
 * @param list весть список куда добавлять, 
 * @param type_var тип выражения 
 */
void pushBack(vector *list, int type_var)
{
        Node *tmp = (Node*)malloc(sizeof(Node));
        if(NULL == tmp)
                exit(2);

        tmp->type          = type_var;
        tmp->next_node     = NULL;
        tmp->parent_node   = list->tail;

        if(list->tail)
                list->tail->next_node = tmp;

        list->tail = tmp;

        if(NULL == list->head)
                list->head = tmp;

        list->size++;
}



/**
 * @brief Функция выводит на экран дерево разбора
 * 
 * @param list весть список 
 */
void print_all(vector *list)
{
        Node *tmp = list->head;
        size_t i=0;

        while(tmp)
        {
                printf("%s.\n", arr_type[tmp->type].type_s);
                tmp = tmp->next_node;
                i++;
                
        }
}



/**
 * @brief Функция получения элемента списка по индексу
 * 
 * @param list весть список 
 * @param indx индекс элемента который хотим получить
 */
Node *getNode(vector *list, size_t indx)
{
        Node *tmp = list->head;
        size_t i=0;
        while(tmp && i<indx)
        {
                tmp = tmp->next_node;
                i++;
        }
        return tmp;
}

/**
 * @brief Функция очистки двухсвязанного списка
 * 
 * @param list весть список 
 */
void clear_list(vector *list)
{
        if(0 == list->size)
                return;
        
        Node *tmp = list->tail;

        size_t i = 0;

        while(tmp && list->size > 0)
        {
                tmp = getNode(list, i);
                i++;
                free(tmp);
                list->size--;
        }

        list->head = NULL;
        list->tail = NULL;
}

void yyerror(char *errmsg)
{
        fprintf(stderr, "%s (%d, %d): %s\n", errmsg, yylineno, count, yytext);
}

int main(int argc, char **argv)
{
        
        sintax_list = list_syntax_init();

        

	arr_type[STATEMENT_NODE].type_s   =  "STATEMENT";
	arr_type[LOGIC_OR_NODE].type_s    =  "  --LOGIC_OR";
	arr_type[LOGIC_AND_NODE].type_s   =  "  --LOGIC_AND";
	arr_type[ASSIGN_NODE].type_s      =  "  --ASSIGN";
	arr_type[LOGIC_NOT_NODE].type_s   =  "  --LOGIC_NOT";
        arr_type[FUNCTION_NODE].type_s    =  "  --FUNCTION";

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