%{
#include <string>
%}

%option noyywrap

ESPACO [ \t]
DIGITO [0-9]
CARACTERE [a-zA-Z_]

DELIM {ESPACO}+
NUM {DIGITO}+
ID {CARACTERE}({CARACTERE}|{DIGITO})*
%%

"\n"		{ linha++; }

{DELIM} 	{}

"+"|"-"|"*"|"/"			{ return *yytext; }

"("                 { return TK_LPAREN; }
")"                 { return TK_RPAREN; }
"="                 { return TK_ASSIGN; }"

{NUM}		{ yylval.label = yytext; return TK_NUM; }
{ID}		{ yylval.label = yytext; return TK_ID; }

.			{ fprintf(stderr, "Caractere nao reconhecido na linha %d: %s\n", linha, yytext); }

%%
