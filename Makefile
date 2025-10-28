CC = gcc
CFLAGS = -Wall -Wextra -O2 -std=c99
TARGET = void
SRC = void.c
OUTPUT_DIR = bin

.PHONY: all clean install uninstall

all: $(OUTPUT_DIR)/$(TARGET)

$(OUTPUT_DIR)/$(TARGET): $(SRC)
	@mkdir -p $(OUTPUT_DIR)
	$(CC) $(CFLAGS) -o $@ $^
	@echo "Build complete: $(OUTPUT_DIR)/$(TARGET)"

clean:
	rm -rf $(OUTPUT_DIR)
	@echo "Cleaned build files"

install: $(OUTPUT_DIR)/$(TARGET)
	install -m 755 $(OUTPUT_DIR)/$(TARGET) /usr/local/bin/
	@echo "Installed to /usr/local/bin/$(TARGET)"

uninstall:
	rm -f /usr/local/bin/$(TARGET)
	@echo "Uninstalled $(TARGET)"

run: $(OUTPUT_DIR)/$(TARGET)
	./$(OUTPUT_DIR)/$(TARGET)