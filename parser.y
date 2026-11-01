/* CMSC 430 Compiler Theory and Design
   Project 2 Skeleton
   UMGC CITE
   Summer 2023 

   Project 2 Parser */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER INT_LITERAL CHAR_LITERAL REAL_LITERAL

%token ADDOP MULOP REMOP EXPOP NEGOP ANDOP OROP NOTOP RELOP ARROW

%token BEGIN_ CASE CHARACTER ELSE END ENDSWITCH FUNCTION INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN ELSIF ENDFOLD ENDIF FOLD IF LEFT REAL RIGHT THEN

%%

function:	
	function_header_ optional_variable body ;

function_header_:
	function_header | 
	error ';';
function_header:
	FUNCTION IDENTIFIER parameters RETURNS type ';'  ;
parameters: 
	parameters ',' parameter | parameter | %empty;
parameter: 
	IDENTIFIER ':' type; 
type:
	INTEGER |
	REAL |
	CHARACTER ;
	
optional_variable:
	optional_variable variable_ |
	%empty ;
    
variable_:
	variable | error ';';
variable:
	IDENTIFIER ':' type IS statement ';' |
	IDENTIFIER ':' LIST OF type IS list ';' ;

list:
	'(' expressions ')' ;

expressions:
	expressions ',' expression| 
	expression ;

body:
	BEGIN_ statement_ END ';' ;

statement_:
	statement ';' |
	error ';' ;
    
statement:
	expression |
	WHEN condition ',' expression ':' expression |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH | ifs | FOLD direction operation list_choice ENDFOLD;

cases:
	cases case_ |
	%empty ;
case_:
	case | error';';
case:
	CASE INT_LITERAL ARROW statement ';' ; 
ifs:
	IF condition THEN statement ';' elsifs ENDIF ';' ;
elsifs: 
	elsifs elsif | %empty; 
elsif:
	ELSIF condition THEN statement ';'| ELSE statement ';';
direction:
	LEFT | RIGHT;
operation: 
	ADDOP | MULOP;
list_choice:
	list |
	IDENTIFIER;
condition:
	condition ANDOP relation |
	relation ;

relation:
	'(' condition ')' |
	expression RELOP expression | NOTOP relation;

expression:
	expression ADDOP term |
	expression NOTOP term|
	term ;
      
term:
	term MULOP factor |
	factor;
factor: 
	urnary EXPOP factor | urnary;
urnary: 
	NEGOP primary urnary | primary; 
primary:
	'(' expression ')' |
	INT_LITERAL |
	CHAR_LITERAL |
	REAL_LITERAL |
	IDENTIFIER '(' expression ')' |
	IDENTIFIER ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
