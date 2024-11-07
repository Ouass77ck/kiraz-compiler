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
"=="          {colno += yyleng; curtoken = Token::New<OpEq>(); return OP_EQ;}
">"          {colno += yyleng; curtoken = Token::New<OpGt>(); return OP_GT;}
"<"          {colno += yyleng; curtoken = Token::New<OpLt>(); return OP_LT;}
">="          {colno += yyleng; curtoken = Token::New<OpGe>(); return OP_GE;}
"<="          {colno += yyleng; curtoken = Token::New<OpLe>(); return OP_LE;}
":"          {colno += yyleng; curtoken = Token::New<OpColon>(); return OP_COLON; }
","          {colno += yyleng; return OP_COMMA; }
";"          {colno += yyleng; return OP_SEMICOLON; }
"{"          {colno += yyleng; return OP_LBRACE; }
"}"          {colno += yyleng; return OP_RBRACE; }


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

"return" {
    colno += yyleng;
    curtoken = Token::New<Keyword>("return");
    return KW_RETURN;
}

"if" {
    colno += yyleng;
    curtoken = Token::New<Keyword>("if");
    return KW_IF;
}
"else" {
    colno += yyleng;
    curtoken = Token::New<Keyword>("else");
    return KW_ELSE;
}

"while" {
    colno += yyleng;
    curtoken = Token::New<Keyword>("while");
    return KW_WHILE;
}
"func" {
    colno += yyleng;
    curtoken = Token::New<Keyword>("func");
    return KW_FUNC;
}
"class" {
    colno += yyleng;
    curtoken = Token::New<Keyword>("class");
    return KW_CLASS;
}
"import" {
    colno += yyleng;
    curtoken = Token::New<Keyword>("import");
    return KW_IMPORT;
}
\"([^\"\\]|\\[\"ntr])*\" {
    colno += yyleng;
    std::string decoded_text;
    for (size_t i = 1; i < yyleng - 1; ++i) {  
        if (yytext[i] == '\\' && i + 1 < yyleng - 1) {
            switch (yytext[i + 1]) {
                case 'n': decoded_text += '\n'; break;
                case 't': decoded_text += '\t'; break;
                case 'r': decoded_text += '\r'; break;
                case '\\': decoded_text += '\\'; break;
                case '"': decoded_text += '"'; break;
                default:
                    decoded_text += '\\';
                    decoded_text += yytext[i + 1];
                    break;
            }
            ++i; 
        } else {
            decoded_text += yytext[i];
        }
    }

    curtoken = Token::New<String>(decoded_text);
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
