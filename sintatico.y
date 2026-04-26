%{
#include <iostream>
#include <string>

#include <map>
#include <vector>

#define YYSTYPE attributes

using namespace std;

struct attributes
{
	string label;
	string traducao;
	string type;
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
map<string, string> alias_types;

int yylex(void);
void yyerror(string);
string gentempcode(string type);
string resultType(string t1, string t2);
%}

%token TK_ID
%token TK_NUM_INT TK_NUM_FLOAT
%token TK_LPAREN TK_RPAREN
%token TK_ASSIGN TK_SEMICOLON
%token TK_TYPE_INT TK_TYPE_FLOAT

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
										string t = "t" + to_string(i);
										codigo_gerado += "\t" + alias_types[t] + " " + t + ";\n";
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
										yyerror("Erro: Variável '" + $2.label + " já declarada!");
									} else {
										string t = gentempcode("int");
										symbol_table[$2.label] = {$2.label, t, "int"};
										$$.traducao = "\tint " + t + ";\n";
									}
								}
								| TK_TYPE_FLOAT TK_ID TK_SEMICOLON
								{
									if(symbol_table.count($2.label)) {
										yyerror("Erro: Variável '" + $2.label + " já declarada!");
									} else {
										string t = gentempcode("float");
										symbol_table[$2.label] = {$2.label, t, "float"};
										$$.traducao = "\tfloat " + t + ";\n";
									}
								}	
								;

ASSIGNMENT			: TK_ID TK_ASSIGN E TK_SEMICOLON
								{
									if(!symbol_table.count($1.label)) {
										yyerror("Erro: Variável '" + $1.label + " não declarada!");
									} else {
										string d = symbol_table[$1.label].alias;
										$$.traducao = $3.traducao + "\t" + d + " = " + $3.label + ";\n";
									}
								}
								;

E								: E '+' E
								{
									$$.label = gentempcode(resultType($1.type, $3.type));
									$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +
										" = " + $1.label + " + " + $3.label + ";\n";
								}
								|	E '-' E
								{
									$$.label = gentempcode(resultType($1.type, $3.type));
									$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +
										" = " + $1.label + " - " + $3.label + ";\n";
								}
								| E '*' E
								{
									$$.label = gentempcode(resultType($1.type, $3.type));
									$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + 
										" = " + $1.label + " * " + $3.label + ";\n";
								}
								| E '/' E
								{
									$$.label = gentempcode(resultType($1.type, $3.type));
									$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + 
										" = " + $1.label + " / " + $3.label + ";\n";
								}
								| TK_LPAREN E TK_RPAREN
								{
									$$.label = $2.label;
									$$.traducao = $2.traducao;
								}
								| TK_NUM_INT
								{
									$$.label = gentempcode("int");
									$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
								}
								| TK_NUM_FLOAT
								{
									$$.label = gentempcode("float");
									$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
								}
								| TK_ID
								{
									$$.label = symbol_table[$1.label].alias;
									$$.type = symbol_table[$1.label].type;
									$$.traducao = "";
								}
								;

%%

#include "lex.yy.c"

int yyparse();

string gentempcode(string type)
{
	var_temp_qnt++;
	string name = "t" + to_string(var_temp_qnt);
	alias_types[name] = type;
	return name;
}
string resultType(string t1, string t2)
{
	if(t1 == "float" || t2 == "float") return "float";
	return "int";
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
