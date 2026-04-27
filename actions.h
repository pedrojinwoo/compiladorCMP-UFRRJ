#ifndef ACTIONS_H
#define ACTIONS_H

#include <iostream>
#include <string>
#include <map>
#include <vector>

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

extern int var_temp_qnt;
extern int linha;
extern string codigo_gerado;
extern map<string, symbol> symbol_table;
extern map<string, string> alias_types;

int yylex();
int yyparse();
void yyerror(string);
string gentempcode(string type);
string resultType(string t1, string t2);
string varDeclaration(string name, string type);
attributes opCodeGenerator(string op, attributes left, attributes right);
attributes litCodeGenerator(string type, string value);

#endif