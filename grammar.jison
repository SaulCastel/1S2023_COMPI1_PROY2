/* Definición Léxica */
%lex

%options case-insensitive

ID							[a-zA-Z_][a-zA-Z0-9_]*
BLOCK_COMMENT		/\*[\s\S]*?\*/
COMMENT 				//.*
NUMBER					[0-9]*
DECIMAL					{NUMBER}.{NUMBER}
ESCAPE					"\\\\"|"\\n"|"\\\""|"\\'"|"\\t"|"\\r"
CHAR						\'[ -~]|{ESCAPE}\'
STRING					\".|{ESCAPE}\"

%%
{BLOCK_COMMENT}	{}
{COMMENT}				{}
"int"						return "INT_TYPE"
"double"				return "DOUBLE_TYPE"
"boolean"				return "BOOLEAN_TYPE"
"char"					return "CHAR_TYPE"
"string"				return "STRING_TYPE"
"true"					return "TRUE"
"false"					return "FALSE"
"new"						return "NEW"
"if"						return "IF"
"else"					return "ELSE"
"switch"				return "SWITCH"
"case"					return "CASE"
"default"				return "DEFAULT"
"while"					return "WHILE"
"for"						return "FOR"
"do"						return "DO"
"break"					return "BREAK"
"continue"			return "CONTINUE"
"return"				return "RETURN"
"void"					return "VOID"
"main"					return "MAIN"
{ID}						return "ID"
"+"							return "SUM"
"-"							return "NEG"
"*"							return "MULT"
"/"							return "DIV"
"^"							return "POWER"
"%"							return "MOD"
"=="						return "EQUALS"
"="							return "ASSIGN"
"!="						return "NOT_EQUALS"
"<"							return "LESS_THAN"
"<="						return "LESS_EQUAL_THAN"
">"							return "GREATER_THAN"
">="						return "GREATER_EQUAL_THAN"
"?"							return "TERNARY"
"||"						return "OR"
"&&"						return "AND"
"!"							return "NOT"
"("							return "LPAREN"
")"							return "RPAREN"
"{"							return "LCURLYBRACKET"
"}"							return "RCURLYBRACKET"
"["							return "LSQRBRACKET"
"]"							return "RSQRBRACKET"
";"							return "SEMICOLON"
":"							return "COLON"
","							return "COMMA"
{NUMBER}				return "INTEGER"
{DECIMAL}				return "DECIMAL"
{CHAR}					return "CHAR"
{STRING}				return "STRING"

<<EOF>>         return 'EOF';
.               { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex

/* Asociación de operadores y precedencia */

%left 'MAS' 'MENOS'
%left 'POR' 'DIVIDIDO'
%left UMENOS

%start ini

%% /* Definición de la gramática */

ini
	: instrucciones EOF
;

instrucciones
	: instruccion instrucciones
	| instruccion
	| error { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
;

instruccion
	: REVALUAR CORIZQ expresion CORDER PTCOMA {
		console.log('El valor de la expresión es: ' + $3);
	}
;

expresion
	: MENOS expresion %prec UMENOS  { $$ = $2 *-1; }
	| expresion MAS expresion       { $$ = $1 + $3; }
	| expresion MENOS expresion     { $$ = $1 - $3; }
	| expresion POR expresion       { $$ = $1 * $3; }
	| expresion DIVIDIDO expresion  { $$ = $1 / $3; }
	| ENTERO                        { $$ = Number($1); }
	| DECIMAL                       { $$ = Number($1); }
	| PARIZQ expresion PARDER       { $$ = $2; }
;