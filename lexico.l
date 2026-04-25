%{
#include <string>
%}

%option noyywrap

ESPACO [ \t]
DIGIT [0-9]
CHARACTER [a-zA-Z_]

DELIM {ESPACO}+
NUM {DIGIT}+
ID {CHARACTER}({CHARACTER}|{DIGIT})*
%%

"\n"		{ linha++; }

{DELIM} 	{}

"+"|"-"|"*"|"/"			{ return *yytext; }

"("                 { return TK_LPAREN; }
")"                 { return TK_RPAREN; }
"="                 { return TK_ASSIGN; }
";"                 { return TK_SEMICOLON; }

"int"               { return TK_TYPE_INT; }

{NUM}		{ yylval.label = yytext; return TK_NUM; }
{ID}		{ yylval.label = yytext; return TK_ID; }

.			{ fprintf(stderr, "Caractere nao reconhecido na linha %d: %s\n", linha, yytext); }

%%
