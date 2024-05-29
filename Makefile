CC = gcc
CINC = -Iinclude/
CFLAGS = -lJakestering -g

VASMC = vasm6502_oldstyle
VASMFLAGS = -Fbin -dotdir -c02

SRC_DIR=src
OBJ_DIR=obj
BIN_DIR=bin

.PHONY: all test backplane clean main 6502 debug

all:main


$(OBJ_DIR)/main.o: $(SRC_DIR)/main.c
	mkdir -p $(OBJ_DIR)
	$(CC) $< -c -o $@ $(CFLAGS)

debug: $(OBJ_DIR)/main.o
	mkdir -p $(BIN_DIR)
	$(CC) $(OBJ_DIR)/main.o -o $(BIN_DIR)/$@ $(CFLAGS)


$(OBJ_DIR)/backplane.o: $(SRC_DIR)/backplane.c
	mkdir -p $(OBJ_DIR)
	$(CC) $< -c -o $@ $(CFLAGS)

backplane: $(OBJ_DIR)/backplane.o
	mkdir -p $(BIN_DIR)
	$(CC) $(OBJ_DIR)/backplane.o -o $(BIN_DIR)/$@ $(CFLAGS)

main: $(SRC_DIR)/main.s
	mkdir -p $(BIN_DIR)
	mkdir -p $(OBJ_DIR)
	ca65 $< -o $(OBJ_DIR)/$@.o
	ld65 -C linker.cfg $(OBJ_DIR)/main.o -o $(BIN_DIR)/$@.o

6502: $(SRC_DIR)/main.s
	mkdir -p $(BIN_DIR)
	$(VASMC) $(VASMFLAGS) $< -o $(BIN_DIR)/bin.o

test: test/backup.s
	mkdir -p $(BIN_DIR)
	$(VASMC) $(VASMFLAGS) $< -o $(BIN_DIR)/bin.o

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)
	clear
