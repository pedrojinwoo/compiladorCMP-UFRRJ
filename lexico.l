%{
#include <string>
%}

%option noyywrap

ESPACO [ \t]
DIGITO [0-9]

DELIM {ESPACO}+
NUM {DIGITO}+

%%

"\n"		{ linha++; }

{DELIM} 	{}

"+"|"-"|"*"|"/"			{ return *yytext; }

"("                 { return TK_LPAREN; }
")"                 { return TK_RPAREN; }

{NUM}		{ yylval.label = yytext; return TK_NUM; }

.			{ fprintf(stderr, "Caractere nao reconhecido na linha %d: %s\n", linha, yytext); }

%%
