%{
  #include "actions.h"
%}

%define YYSTYPE attributes

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
									$$.traducao = varDeclaration($2.label, "int");
								}
								| TK_TYPE_FLOAT TK_ID TK_SEMICOLON
								{
									$$.traducao = varDeclaration($2.label, "float");
								}
								| TK_TYPE_CHAR TK_ID TK_SEMICOLON
								{
									$$.traducao = varDeclaration($2.label, "char");
								}
								| TK_TYPE_BOOL TK_ID TK_SEMICOLON
								{
									$$.traducao = varDeclaration($2.label, "int");
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
									$$.label = symbol_table[$1.label].alias;
									$$.type = symbol_table[$1.label].type;
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