# Nome dell'eseguibile
TARGET = db

# Cartelle
SRC_DIR = Source
HEADER_DIR = Header

# File sorgenti e header
SRCS = db.c $(SRC_DIR)/function.c $(SRC_DIR)/constants.c
HEADERS = $(HEADER_DIR)/function.h $(HEADER_DIR)/type.h $(HEADER_DIR)/constants.h

# Compilatore e flag
CC = gcc
CFLAGS = -I$(HEADER_DIR) -Wall -g

# Regola per creare l'eseguibile
$(TARGET): $(SRCS) $(HEADERS)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRCS)

# Regola per pulire i file generati
clean:
	rm -f $(TARGET)

# Regola per la compilazione incrementale
%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@