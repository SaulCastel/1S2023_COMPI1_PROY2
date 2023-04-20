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
"print"					return "PRINT"
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
%left POWER
%left DIV, MULT
%left SUM, NEG
%left EQUALS, NOT_EQUALS, LESS_THAN, LESS_EQUAL_THAN, GREATER_THAN, GREATER_EQUAL_THAN
%left NOT
%left AND
%left OR

%start init

%% /* Definición de la gramática */

init
	: instructions EOF
;

instructions
	:	instructions instruction	
	| instruction
;

instruction
	:	expressions
	| statements
;

expressions
	: arithmethic-expression
	| unary-expression
	| ternary-expression
	| logical-expression
	| relational-expression
	| group-expression
	| function-call
	| type-casting
	| increment
	| decrement
	| error { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
;

arithmethic-expression
	:	expressions SUM expressions
	| expressions NEG expressions
	| expressions MULT expressions
	| expressions DIV expressions
	| expressions POWER expressions
	| expressions MOD expressions
;

unary-expression
	: NEG expressions
	| expressions SUM SUM
	| expressions NEG NEG
;

ternary-expression
	:	expressions TERNARY TRUE COLON FALSE
;

logical-expression
	:	expressions OR expressions
	:	expressions AND expressions
	:	NOT expressions
;

relational-expresion
	:	expresssions EQUALS expressions
	|	expresssions NOT_EQUALS expressions
	|	expresssions LESS_THAN expressions
	|	expresssions LESS_EQUAL_THAN expressions
	|	expresssions GREATER_THAN expressions
	|	expresssions GREATER_EQUAL_THAN expressions
;

group-expresion
	: LPAREN expressions RPAREN
;

function-call
	:	PRINT LPAREN arguments RPAREN
	| ID LPAREN arguments RPAREN
;

arguments
	: arguments COMMA expressions
	| expressions
;

type-casting
	: LPAREN native-type RPAREN expressions
;

statements
	: inline-statement
	| block-statement
;

inline-statement
	: variable-statement SEMICOLON
	| function-call SEMICOLON
	| unary-expression SEMICOLON
;

variable-statement
	: native-type ID
	| native-type ID ASSIGN expressions
;

native-type
	:	INT_TYPE
	| STRING_TYPE
	| DOUBLE_TYPE
	| CHAR_TYPE
	| BOOLEAN_TYPE
;

block-statement
	: 
;