/* 声明部分 */
%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>

int total=0;
 /* 总共的字符数 */
int lineno=1;
/* 行数 */
int ID=0; 
/* 标识符的个数 */
int NUM=0;
 /* 数字的个数 */
int reserved=0;
/* 保留字的个数 */
int special=0;
/* 特殊符号总数 */
int annotate=0;
/* 注释的条数 */
%}

letter [A-Za-z]
digit  [0-9]
id ({letter}|[_])({letter}|{digit}|[_])*
error_id ({digit})({letter}|{digit}|[_])*
num {digit}+
whitespace [ \t]+
enter [\n]+
annotate1 "//".*
annotate2 "/*"([^\*]|(\*)*[^\*/])*(\*)*"*/"

%%
 /* 识别保留字 */
"int"|"else"|"return"|"void"|"if"|"while"|"char"|"long"|"float"|"double"|"short"|"case"|"for"|"switch"|"break"|"sizeof"|"struct"|"NULL"|"include" {
printf("第%d行	 ",lineno);
printf("< %s,保留字 >\n",yytext);
reserved++;
total+=yyleng;
}
 /* 识别数字 */
{num} {printf("第%d行	",lineno);
printf("< %s,数字 >\n",yytext);
NUM++;
total+=yyleng;
}
 /* 识别变量 */
{id} {printf("第%d行	",lineno);
printf("< %s,变量 >\n",yytext);
ID++;
total+=yyleng;
}
 /* 识别特殊符号 */
","|";"|"("|")"|"{"|"}"|"*"|"/"|"+"|"-"|">"|"<"|">="|"<="|"="|"#"|"." {printf("%d行",lineno);
printf("< %s,特殊符号 >\n",yytext);
special++;
total+=yyleng;
}
 /* 识别错误的标志符 */
{error_id} {printf("第%d行	",lineno);
printf("%s是一个错误的标识符\n",yytext);
total+=yyleng;
}
 /* 识别空格 */
{whitespace} {}
 /* 遇到空格直接忽略 */
 /* 识别回车 */
{enter} {lineno++;}  /* 遇到回车自动加行号忽略 */
 /* 识别行型注释 */
{annotate1} {
annotate++;
printf("<%s,注释>\n",yytext);
total+=yyleng;
}
{annotate2} {
printf("<%s,注释>\n",yytext);
annotate++;
total+=yyleng;
}

%%
void main(void)
{
char infilename[400];
printf("请输入文件名：");
scanf("%s",infilename);
yyin = fopen(infilename,"r");
printf("开始词法分析： \n");
yylex();
fclose(yyin);
printf("共有%d行",lineno);
printf("共有%d个字符\n",total);
printf("共有%d个单词\n",ID);
printf("共有%d个数字\n",NUM);
printf("共有%d个保留字\n",reserved);
printf("共有%d个特殊符号\n",special);
printf("共有%d条注释\n",annotate);
}
int yywrap()
{
return 1;
}

