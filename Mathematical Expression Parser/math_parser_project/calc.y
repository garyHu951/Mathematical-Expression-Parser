/* calc.y - 數學運算式語法分析器 */
%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* 外部函數宣告 */
extern int yylex();
extern char *yytext;
extern int line_num;

/* 錯誤處理函數 */
int yyerror(char *s);

/* 語義值聯合 */
%}

%union {
    int ival;      /* 整數值 */
    double fval;   /* 浮點數值 */
}

/* Token 定義 */
%token <ival> INTEGER
%token <fval> FLOAT
%token PLUS MINUS MULTIPLY DIVIDE POWER
%token LPAREN RPAREN
%token NEWLINE EQUALS ERROR

/* 非終結符號類型定義 */
%type <fval> expression term factor power number

/* 運算子優先權與結合性 */
%left PLUS MINUS           /* 最低優先權，左結合 */
%left MULTIPLY DIVIDE      /* 中等優先權，左結合 */
%right POWER              /* 最高優先權，右結合 */
%left UMINUS              /* 一元負號 */

/* 開始符號 */
%start program

%%

/* 語法規則與語義動作 */
program:
    /* 空程式 */
    | program line
    ;

line:
    NEWLINE                     {
                                    printf("語法分析: 空行\n");
                                }
    | expression NEWLINE        {
                                    printf("語法分析: 運算式結果 = %.6f\n", $1);
                                    printf("=====================================\n");
                                }
    | expression EQUALS NEWLINE {
                                    printf("語法分析: 指派運算式結果 = %.6f\n", $1);
                                    printf("=====================================\n");
                                }
    | error NEWLINE             {
                                    printf("語法錯誤: 無法解析的運算式\n");
                                    yyerrok;  /* 錯誤恢復 */
                                }
    ;

expression:
    term                        {
                                    $$ = $1;
                                    printf("語義規則: expression <- term (%.6f)\n", $$);
                                }
    | expression PLUS term      {
                                    $$ = $1 + $3;
                                    printf("語義規則: %.6f + %.6f = %.6f\n", $1, $3, $$);
                                }
    | expression MINUS term     {
                                    $$ = $1 - $3;
                                    printf("語義規則: %.6f - %.6f = %.6f\n", $1, $3, $$);
                                }
    ;

term:
    factor                      {
                                    $$ = $1;
                                    printf("語義規則: term <- factor (%.6f)\n", $$);
                                }
    | term MULTIPLY factor      {
                                    $$ = $1 * $3;
                                    printf("語義規則: %.6f * %.6f = %.6f\n", $1, $3, $$);
                                }
    | term DIVIDE factor        {
                                    if ($3 == 0.0) {
                                        printf("語義錯誤: 除以零 (行號: %d)\n", line_num);
                                        YYERROR;
                                    }
                                    $$ = $1 / $3;
                                    printf("語義規則: %.6f / %.6f = %.6f\n", $1, $3, $$);
                                }
    ;

factor:
    power                       {
                                    $$ = $1;
                                    printf("語義規則: factor <- power (%.6f)\n", $$);
                                }
    ;

power:
    number                      {
                                    $$ = $1;
                                    printf("語義規則: power <- number (%.6f)\n", $$);
                                }
    | number POWER power        {
                                    $$ = pow($1, $3);
                                    printf("語義規則: %.6f ^ %.6f = %.6f\n", $1, $3, $$);
                                }
    | MINUS power %prec UMINUS  {
                                    $$ = -$2;
                                    printf("語義規則: 一元負號 -%.6f = %.6f\n", $2, $$);
                                }
    ;

number:
    INTEGER                     {
                                    $$ = (double)$1;
                                    printf("語義規則: 整數轉浮點數 %d -> %.6f\n", $1, $$);
                                }
    | FLOAT                     {
                                    $$ = $1;
                                    printf("語義規則: 浮點數 %.6f\n", $$);
                                }
    | LPAREN expression RPAREN  {
                                    $$ = $2;
                                    printf("語義規則: 括號運算式 (%.6f)\n", $$);
                                }
    ;

%%

/* 錯誤處理函數 */
int yyerror(char *s) {
    printf("語法錯誤: %s (行號: %d, 當前token: '%s')\n", s, line_num, yytext);
    return 0;
}

/* 主程式 */
int main() {
    printf("數學運算式解析器\n");
    printf("支援運算: +, -, *, /, ^ (次方), 括號\n");
    printf("輸入運算式後按 Enter，輸入空行結束\n");
    printf("=====================================\n");
    
    return yyparse();
}
