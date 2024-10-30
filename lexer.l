
%option noyywrap
%option yylineno

%{
// https://stackoverflow.com/questions/9611682/flexlexer-support-for-unicode/9617585#9617585
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

[0-9]+ {
    colno += yyleng;
    curtoken = Token::New<Integer>(10, yytext);
    return L_INTEGER;
}



[ \t\n]+ {colno += yyleng;}


.   {
    colno += yyleng;
    curtoken = Token::New<Rejected>(yytext);
    fprintf(stderr, "** Lexer Error at line %d, column %d: Unrecognized token '%s'\n", yylineno, colno, yytext);
    return REJECTED;
}