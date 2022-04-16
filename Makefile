TARGET = lexer

NAME_H_B = gramer

CC 	   = gcc
LEX    = flex
BISON  = bison

LEXWLAGS   = --header-file=
BISONWLAGS = --defines=

PREF_SRC = ./src/
PREF_OBJ = ./obj/
PREF_LEX = ./src/lex/
PREF_BISON = ./src/bison/
PREF_INCLUD = ./src/include/

SRC = $(wildcard $(PREF_SRC)*.c)
OBJ = $(patsubst $(PREF_SRC)%.c, $(PREF_OBJ)%.o, $(SRC))

# all : $(TARGET)
all:

	$(BISON) $(PREF_BISON)*.y $(BISONWLAGS)$(PREF_INCLUD)$(NAME_H_B).h -o $(PREF_SRC)$(NAME_H_B).c

	$(LEX) $(LEXWLAGS)$(PREF_INCLUD)$(TARGET).h -o $(PREF_SRC)$(TARGET).c -c $(PREF_LEX)$(TARGET).l	
	gcc $(PREF_SRC)*.c -o ./obj/lexer.o
	



clean : 
	rm $(PREF_OBJ)*.o $(PREF_SRC)*.c $(PREF_INCLUD)*.h 



