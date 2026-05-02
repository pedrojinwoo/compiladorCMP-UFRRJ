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
void varDeclaration(string name, string type);
attributes opCodeGenerator(string op, attributes left, attributes right);
attributes litCodeGenerator(string type, string value);
%}

%token TK_SEMICOLON
%token TK_ID TK_NUM_INT TK_NUM_FLOAT TK_CHAR TK_BOOL
%token TK_LPAREN TK_RPAREN
%token TK_ASSIGN TK_EQ TK_NEQ TK_LT TK_GT TK_LEQ TK_GEQ
%token TK_TYPE_INT TK_TYPE_FLOAT TK_TYPE_CHAR TK_TYPE_BOOL

%start S

%right TK_ASSIGN
%left TK_EQ TK_NEQ 
%left TK_LT TK_GT TK_LEQ TK_GEQ
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
									varDeclaration($2.label, "int");
									$$.traducao = "";
								}
								| TK_TYPE_FLOAT TK_ID TK_SEMICOLON
								{
									varDeclaration($2.label, "float");
									$$.traducao = "";
								}
								| TK_TYPE_CHAR TK_ID TK_SEMICOLON
								{
									varDeclaration($2.label, "char");
									$$.traducao = "";
								}
								| TK_TYPE_BOOL TK_ID TK_SEMICOLON
								{
									varDeclaration($2.label, "int");
									$$.traducao = "";
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
									$$ = opCodeGenerator("+", $1, $3);
								}
								|	E '-' E
								{
									$$ = opCodeGenerator("-", $1, $3);
								}
								| E '*' E
								{
									$$ = opCodeGenerator("*", $1, $3);
								}
								| E '/' E
								{
									$$ = opCodeGenerator("/", $1, $3);
								}
								| TK_LPAREN E TK_RPAREN
								{
									$$.label = $2.label;
									$$.traducao = $2.traducao;
								}
								| TK_NUM_INT
								{
									$$ = litCodeGenerator("int", $1.label);
								}
								| TK_NUM_FLOAT
								{
									$$ = litCodeGenerator("float", $1.label);
								}
								| TK_CHAR
								{
									$$ = litCodeGenerator("char", $1.label);
								}
								| TK_BOOL
								{
									$$ = litCodeGenerator("int", $1.label);
								}
								| TK_ID
								{
									$$.label = gentempcode("int");
									$$.type = "int";
									$$.traducao = "";
								}
								| E TK_EQ E
								{
									$$ = opCodeGenerator("==", $1, $3);
								}
								| E TK_NEQ E
								{
									$$ = opCodeGenerator("!=", $1, $3);
								}
								| E TK_LT E
								{
									$$ = opCodeGenerator("<", $1, $3);
								}
								| E TK_GT E
								{
									$$ = opCodeGenerator(">", $1, $3);
								}
								| E TK_LEQ E
								{
									$$ = opCodeGenerator("<=", $1, $3);
								}
								| E TK_GEQ E
								{
									$$ = opCodeGenerator(">=", $1, $3);
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
	if(t1 == "error" || t2 == "error") return "error";
	if(t1 == "char" || t2 == "char") return "error";
	if(t1 == "float" || t2 == "float") return "float";
	return "int";
}
void varDeclaration(string name, string type)
{
	if(symbol_table.count(name)) {
		yyerror("Erro: Variável '" + name + " já declarada!");
	} else {
		string t = gentempcode(type);
		symbol_table[name] = {name, t, type};
	}
}
attributes opCodeGenerator(string op, attributes left, attributes right)
{
	attributes r;
	
	string result_type = resultType(left.type, right.type);
	if(result_type == "error") {
		yyerror("Erro: Operação inválida entre tipos '" + left.type + "' e '" + right.type + "'!");
		r.label = "";
		r.type = "";
		r.traducao = "";
		return r;
	} else {
		r.label = gentempcode(result_type);
		r.type = result_type;
		r.traducao = left.traducao + right.traducao + "\t" + r.label + " = " + left.label + 
								 " " + op + " " + right.label + ";\n";
		return r;
	}
}
attributes litCodeGenerator(string type, string value)
{
	attributes r;
	r.label = gentempcode(type);
	r.type = type;
	r.traducao = "\t" + r.label + " = " + value + ";\n";
	return r;
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
