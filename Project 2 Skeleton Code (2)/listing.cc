// CMSC 430 Compiler Theory and Design
// Project 2 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the bodies of the functions that produces the 
// compilation listing
//01.28.26
//Replaced the listing.cc with the listing.cc from project 01

#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexicalErrors = 0; 
static int syntacticErrors = 0; 
static int semanticErrors = 0; 
static string error2 = "";
static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	totalErrors = lexicalErrors + syntacticErrors + semanticErrors;
	printf("     \n");
		if (totalErrors > 0) {
			printf("Lexical Errors %d \n" , lexicalErrors);
			printf("Syntax Errors %d \n" , syntacticErrors);
			printf("Semantic Errors %d \n" , semanticErrors);
		}
		else {
			printf("Compiled Successfully");
		}
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate ",
		"Semantic Error, Undeclared " };

	error = messages[errorCategory] + message;
	ErrorCategories e = LEXICAL;

	switch(e)
	{
	case LEXICAL: lexicalErrors++; break;
	case SYNTAX: syntacticErrors++; break;
	case GENERAL_SEMANTIC: semanticErrors++; break;
	}
	totalErrors++;
}

void displayErrors()
{
	for (int i=0; i < totalErrors; i++){
    if (error != "")  
    printf("%s\n", error.c_str());
  }
	error = "";
}
