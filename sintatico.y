%{
#include <iostream>
#include <string>

#include <map>
#include <vector>

#define YYSTYPE atributos

using namespace std;

struct atributos
{
	string label;
	string traducao;
};
struct symbol
{
	string id;
	string alias;
	string type;
};

int var_temp_qnt;
int linha = 1;
string codigo_gerado;
map<string, symbol> symbol_table;

int yylex(void);
void yyerror(string);
string gentempcode();
%}

%token TK_NUM TK_ID
%token TK_LPAREN TK_RPAREN
%token TK_ASSIGN TK_SEMICOLON
%token TK_TYPE_INT

%start S

%right TK_ASSIGN
%left '+' '-'
%left '*' '/'

%%

S 							: CMDS
								{
									codigo_gerado = "/*Compilador FOCA*/\n"
													"#include <stdio.h>\n"
													"int main(void) {\n";

									for(int i=1; i<=var_temp_qnt; i++) {
										codigo_gerado += "\tint t" + to_string(i) + ";\n";
									}

									codigo_gerado += $1.traducao;

									codigo_gerado += "\treturn 0;"
												"\n}\n";
								}
								;

CMDS 						: CMDS CMD
								{
									$$.traducao = $1.traducao + $2.traducao;
								}
								| CMD
								{
									$$.traducao = $1.traducao;
								}
								;

CMD							: DECLARATION
								{
									$$.traducao = $1.traducao;
								}
								| ASSIGNMENT
								{
									$$.traducao = $1.traducao;
								}
								;

DECLARATION			: TK_TYPE_INT TK_ID TK_SEMICOLON
								{
									if(symbol_table.count($2.label)) {
										yy.error("Erro: Variável '" + $2.label + " já declarada!");
									} else {
										string t = gentempcode();
										symbol_table[$2.label] = {$2.label, t, "int"};

									}
								}
								;

ASSIGNMENT			: TK_ID TK_ASSIGN E TK_SEMICOLON
								{
									if(!symbol_table.count($1.label)) {
										yy.error("Erro: Variável '" + $1.label + " não declarada!");
									} else {
										string d = symbol_table[$1.label].alias;
										$$.traducao = $3.traducao + "\t" + d + " = " + $3.label + ";\n";
									}
								}
								;

E 							: TK_ID TK_ASSIGN E
								{
									$$.label = $1.label;
									$$.traducao = $3.traducao + "\t" + $$.label + " = " + $3.label + ";\n";
								}
								| E '+' E
								{
									$$.label = gentempcode();
									$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +
										" = " + $1.label + " + " + $3.label + ";\n";
								}
								|	E '-' E
								{
									$$.label = gentempcode();
									$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +
										" = " + $1.label + " - " + $3.label + ";\n";
								}
								| E '*' E
								{
									$$.label = gentempcode();
									$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + 
										" = " + $1.label + " * " + $3.label + ";\n";
								}
								| E '/' E
								{
									$$.label = gentempcode();
									$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + 
										" = " + $1.label + " / " + $3.label + ";\n";
								}
								| TK_LPAREN E TK_RPAREN
								{
									$$.label = $2.label;
									$$.traducao = $2.traducao;
								}
								| TK_NUM
								{
									$$.label = gentempcode();
									$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
								}
								| TK_ID
								{
									$$.label = gentempcode();
									$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
								}
								;

%%

#include "lex.yy.c"

int yyparse();

string gentempcode()
{
	var_temp_qnt++;
	return "t" + to_string(var_temp_qnt);
}

int main(int argc, char* argv[])
{
	var_temp_qnt = 0;

	if (yyparse() == 0)
		cout << codigo_gerado;

	return 0;
}

void yyerror(string MSG)
{
	cerr << "Erro na linha " << linha << ": " << MSG << endl;
}
