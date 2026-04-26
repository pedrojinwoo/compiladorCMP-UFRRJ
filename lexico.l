%{
#include <string>
%}

%option noyywrap

ESPACO [ \t]
DIGIT [0-9]
CHARACTER [a-zA-Z_]

DELIM               {ESPACO}+
NUM_INT             {DIGIT}+
NUM_FLOAT           {DIGIT}+"."{DIGIT}+
ID                  {CHARACTER}({CHARACTER}|{DIGIT})*
CHAR                {"'"{CHARACTER}"'"}
%%

"\n"		            { linha++; }

{DELIM} 	          {}

"+"|"-"|"*"|"/"			{ return *yytext; }

"("                 { return TK_LPAREN; }
")"                 { return TK_RPAREN; }
"="                 { return TK_ASSIGN; }
";"                 { return TK_SEMICOLON; }

"int"               { return TK_TYPE_INT; }
"float"             { return TK_TYPE_FLOAT; }
"char"              { return TK_TYPE_CHAR; }
"bool"              { return TK_TYPE_BOOL; }

{NUM_INT}		        { yylval.label = yytext; return TK_NUM_INT; }
{NUM_FLOAT}	        { yylval.label = yytext; return TK_NUM_FLOAT; }
{ID}		            { yylval.label = yytext; return TK_ID; }
{CHAR}	            { yylval.label = yytext.substr(1, yytext.length() - 2); return TK_CHAR; }
"true"              { yylval.label = "1"; return TK_BOOL; }
"false"             { yylval.label = "0"; return TK_BOOL; }

.			{ fprintf(stderr, "Caractere nao reconhecido na linha %d: %s\n", linha, yytext); }

%%
