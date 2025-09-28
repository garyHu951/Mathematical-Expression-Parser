# Makefile for 數學運算式解析器
# 編譯 Flex 和 Bison 程式

CC = gcc
CFLAGS = -Wall -g
FLEX = flex
BISON = bison

# 目標檔案
TARGET = calc
FLEX_FILE = calc.l
BISON_FILE = calc.y

# 中間檔案
LEX_OUTPUT = lex.yy.c
YACC_OUTPUT = calc.tab.c
YACC_HEADER = calc.tab.h

# 預設目標
all: $(TARGET)

# 編譯最終執行檔
$(TARGET): $(LEX_OUTPUT) $(YACC_OUTPUT)
	@echo "正在編譯最終執行檔..."
	$(CC) $(CFLAGS) -o $(TARGET) $(LEX_OUTPUT) $(YACC_OUTPUT) -lm
	@echo "編譯完成！執行檔：$(TARGET)"

# 生成 Bison 輸出
$(YACC_OUTPUT) $(YACC_HEADER): $(BISON_FILE)
	@echo "正在執行 Bison 語法分析器生成..."
	$(BISON) -d $(BISON_FILE)
	@echo "Bison 生成完成"

# 生成 Flex 輸出
$(LEX_OUTPUT): $(FLEX_FILE) $(YACC_HEADER)
	@echo "正在執行 Flex 詞法分析器生成..."
	$(FLEX) $(FLEX_FILE)
	@echo "Flex 生成完成"

# 清理編譯檔案
clean:
	@echo "清理編譯檔案..."
	rm -f $(TARGET) $(LEX_OUTPUT) $(YACC_OUTPUT) $(YACC_HEADER)
	@echo "清理完成"

# 重新編譯
rebuild: clean all

# 執行測試
test: $(TARGET)
	@echo "執行測試範例..."
	@echo "測試 1: 3 + 4 * 2"
	@echo "3 + 4 * 2" | ./$(TARGET)
	@echo ""
	@echo "測試 2: (3 + 4) * 2"
	@echo "(3 + 4) * 2" | ./$(TARGET)
	@echo ""
	@echo "測試 3: 2 ^ 3 ^ 2"
	@echo "2 ^ 3 ^ 2" | ./$(TARGET)
	@echo ""
	@echo "測試 4: -5 + 3"
	@echo "-5 + 3" | ./$(TARGET)

# 互動模式執行
run: $(TARGET)
	@echo "啟動互動模式..."
	./$(TARGET)

# 顯示說明
help:
	@echo "數學運算式解析器 Makefile"
	@echo "可用的目標："
	@echo "  all      - 編譯程式 (預設)"
	@echo "  clean    - 清理編譯檔案"
	@echo "  rebuild  - 重新編譯"
	@echo "  test     - 執行測試範例"
	@echo "  run      - 啟動互動模式"
	@echo "  help     - 顯示此說明"

.PHONY: all clean rebuild test run help
