.PHONY: all clean

CC = gcc

BUILDDIR = ./build
SRCDIR = ./src
PRSDIR = ./parser
INCDIR = ./include
FLEXFILES = $(patsubst $(PRSDIR)/%.l, $(SRCDIR)/%.c, $(wildcard $(PRSDIR)/*.l))
BISONFILES = $(patsubst $(PRSDIR)/%.y, $(SRCDIR)/%.c, $(wildcard $(PRSDIR)/*.y))
OBJECTS = $(patsubst $(SRCDIR)/%.c, $(BUILDDIR)/%.o, $(wildcard $(SRCDIR)/*.c))

MAIN_OBJ = main

INC += -I$(INCDIR)

COMPILE = $(CC) $(INC) -c $< -o $@
# не нашел способа адекватнее в мейке разделить на две директории
BISON = bison -o $@ --header=$(INCDIR)/$(basename $(notdir $@)).h $<
FLEX = flex -o $@ -i $<
LINK=$(CC) -o $@

$(SRCDIR)/%.c $(SRCDIR)/%.h: $(PRSDIR)/%.y
	$(BISON)

$(SRCDIR)/%.c: $(PRSDIR)/%.l
	$(FLEX)

$(BUILDDIR)/%.o: $(SRCDIR)/%.c
	$(COMPILE)

all: $(MAIN_OBJ)

$(MAIN_OBJ): $(FLEXFILES) $(BISONFILES) $(OBJECTS)
	$(LINK) $(OBJECTS)

clean:
	rm -rf $(BUILDDIR)/*.o
	rm -f $(MAIN_OBJ)
	rm -f $(SRCDIR)/bison.c
	rm -f $(SRCDIR)/lex.c
	rm -f $(INCDIR)/bison.h
