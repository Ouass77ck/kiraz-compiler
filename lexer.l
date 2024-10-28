
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
"("          {colno += yyleng; curtoken = Token::New<OpLParent>(); return OP_LPAREN;}
")"          {colno += yyleng; curtoken = Token::New<OpRParent>(); return OP_RPAREN;}

.        ;
