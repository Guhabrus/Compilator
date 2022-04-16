TARGET = lexer

CC 	   = gcc
LEX    = flex

LEXWLAGS = --header-file=


PREF_SRC = ./src/
PREF_OBJ = ./obj/
PREF_LEX = ./src/lex/

SRC = $(wildcard $(PREF_SRC)*.c)
OBJ = $(patsubst $(PREF_SRC)%.c, $(PREF_OBJ)%.o, $(SRC))

all : $(TARGET)
	
	
lex:
	$(LEX) $(LEXWLAGS)$(PREF_SRC)$(TARGET).h -o $(PREF_SRC)$(TARGET).c -c $(PREF_LEX)$(TARGET).l
		

$(TARGET) : $(OBJ)
	$(CC) $(OBJ) -o $(TARGET)


$(PREF_OBJ)%.o : $(PREF_SRC)%.c
	$(CC) -c $< -o $@



clean : 
	rm $(TARGET) $(PREF_OBJ)*.o $(PREF_SRC)*.c $(PREF_SRC)*.h 



