/* calc.l - 數學運算式詞法分析器 */
%{
#include <stdio.h>
#include <stdlib.h>
#include "calc.tab.h"  /* Bison 生成的標頭檔 */

/* 全域變數用於錯誤處理 */
extern int yyerror(char *s);
int line_num = 1;
%}

/* Flex 選項 */
%option noyywrap

/* 正規表示式定義 */
DIGIT    [0-9]
INTEGER  {DIGIT}+
FLOAT    {DIGIT}+\.{DIGIT}+
WHITESPACE [ \t]+

%%

{WHITESPACE}    { /* 忽略空白字元 */ }

{FLOAT}         {
                    yylval.fval = atof(yytext);
                    printf("詞法分析: 浮點數 = %f\n", yylval.fval);
                    return FLOAT;
                }

{INTEGER}       {
                    yylval.ival = atoi(yytext);
                    printf("詞法分析: 整數 = %d\n", yylval.ival);
                    return INTEGER;
                }

"+"             {
                    printf("詞法分析: 加號運算子\n");
                    return PLUS;
                }

"-"             {
                    printf("詞法分析: 減號運算子\n");
                    return MINUS;
                }

"*"             {
                    printf("詞法分析: 乘號運算子\n");
                    return MULTIPLY;
                }

"/"             {
                    printf("詞法分析: 除號運算子\n");
                    return DIVIDE;
                }

"^"             {
                    printf("詞法分析: 次方運算子\n");
                    return POWER;
                }

"("             {
                    printf("詞法分析: 左括號\n");
                    return LPAREN;
                }

")"             {
                    printf("詞法分析: 右括號\n");
                    return RPAREN;
                }

"\n"            {
                    line_num++;
                    printf("詞法分析: 換行\n");
                    return NEWLINE;
                }

"="             {
                    printf("詞法分析: 等號\n");
                    return EQUALS;
                }

.               {
                    printf("詞法錯誤: 無法識別的字元 '%c' (行號: %d)\n", yytext[0], line_num);
                    return ERROR;
                }

%%

/* 詞法分析器輔助函數 */
void reset_lexer() {
    line_num = 1;
    printf("詞法分析器已重設\n");
}
