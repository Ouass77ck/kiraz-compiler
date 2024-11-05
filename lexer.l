%option noyywrap
%option yylineno

%{
#include "main.h"
#include <kiraz/token/Literal.h>
#include <kiraz/token/Operator.h>
static auto &colno = Token::colno;
using namespace token;
extern std::shared_ptr<Token> curtoken;
%}

%%

"+"          {colno += yyleng; curtoken = Token::New<OpPlus>(); return OP_PLUS;}
"-"          {colno += yyleng; curtoken = Token::New<OpMinus>(); return OP_MINUS;}
"*"          {colno += yyleng; curtoken = Token::New<OpMult>(); return OP_MULT;}
"/"          {colno += yyleng; curtoken = Token::New<OpDivF>(); return OP_DIVF;}
"("          {colno += yyleng; curtoken = Token::New<OpLparen>(); return OP_LPAREN;}
")"          {colno += yyleng; curtoken = Token::New<OpRparen>(); return OP_RPAREN;}
"="          {colno += yyleng; curtoken = Token::New<OpAssign>(); return OP_ASSIGN;}
":"          {colno += yyleng; curtoken = Token::New<OpColon>(); return OP_COLON; }
";"          {colno += yyleng; curtoken = Token::New<OpColon>(); return OP_SEMICOLON; }


[0-9]+ {
    colno += yyleng;
    curtoken = Token::New<Integer>(10, yytext);
    return L_INTEGER;
}

"let" {
    colno += yyleng;
    curtoken = Token::New<Keyword>("let");
    return KW_LET;
}

\"([^\"\\]|\\[\"ntr])*\" {
    colno += yyleng;
    curtoken = Token::New<String>(yytext);
    return SSTRING;
}

[a-zA-Z_]+[a-zA-Z0-9_]* {
    colno += yyleng;
    curtoken = Token::New<Identifier>(yytext);
    return IDENTIFIER;
}

[0-9]+[A-Z]{1}[a-z]+ {
    colno += yyleng;
    curtoken = Token::New<Type>(yytext);
    return TYPE;
}
[ \t\n]+ {colno += yyleng; }

. {
    colno += yyleng;
    curtoken = Token::New<Rejected>(yytext);
    fprintf(stderr, "** Lexer Error at line %d, column %d: Unrecognized token '%s'\n", yylineno, colno, yytext);
    return REJECTED;
}
