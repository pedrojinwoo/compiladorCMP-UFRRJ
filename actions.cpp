#include "actions.h"
#include "parser.tab.h"

int var_temp_qnt = 0;
int linha = 1;
string codigo_gerado = "";
map<string, symbol> symbol_table;
map<string, string> alias_types;

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

string varDeclaration(string name, string type)
{
	if(symbol_table.count(name)) {
		yyerror("Erro: Variável '" + name + " já declarada!");
		return "";
	} else {
		string t = gentempcode(type);
		symbol_table[name] = {name, t, type};
		return "\t" + type + " " + t + ";\n";
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

#include "lex.yy.c"