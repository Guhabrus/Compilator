TARGET = lexer

NAME_H_B = gramer

CC 	   = gcc
LEX    = flex
BISON  = bison

LEXWLAGS   = --header-file=
BISONWLAGS = --defines=

PREF_PRJ = ./project/
PREF_OBJ = ./obj/
PREF_LEX = ./project/lex/
PREF_SRC = ./project/src/
PREF_BISON = ./project/bison/
PREF_INCLUD = ./project/include/

PRJ = $(wildcard $(PREF_SRC)*.c)
OBJ = $(patsubst $(PREF_SRC)%.c, $(PREF_SRC)%.o, $(PRJ))

# all : $(TARGET)
all:
	mkdir -p obj
	mkdir -p $(PREF_PRJ)include
	mkdir -p $(PREF_PRJ)src
	$(BISON) $(PREF_BISON)*.y $(BISONWLAGS)$(PREF_INCLUD)$(NAME_H_B).h -o $(PREF_SRC)$(NAME_H_B).c

	$(LEX) $(LEXWLAGS)$(PREF_INCLUD)$(TARGET).h -o $(PREF_SRC)$(TARGET).c -c $(PREF_LEX)$(TARGET).l	
	gcc $(PREF_SRC)*.c -o ./obj/lexer.o
	

clean_o:
	rm -Rf $(PREF_OBJ)

clean_c:
	rm -Rf $(PREF_SRC)

clean_h:
	rm -Rf $(PREF_INCLUD) 

clean : clean_o clean_c clean_h



