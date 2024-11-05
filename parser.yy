%{
#include "lexer.hpp"

#include <kiraz/ast/Operator.h>
#include <kiraz/ast/Literal.h>
#include <kiraz/token/Literal.h>

int yyerror(const char *msg);
extern std::shared_ptr<Token> curtoken;
extern int yylineno;
%}

%token KW_LET
%token IDENTIFIER
%token OP_ASSIGN
%token OP_LPAREN
%token OP_RPAREN
%token OP_PLUS
%token OP_MINUS
%token OP_DIVF
%token OP_MULT
%token OP_COLON
%token OP_SEMICOLON

%token L_INTEGER
%token TYPE
%token SSTRING

%token REJECTED

%left OP_PLUS OP_MINUS
%left OP_MULT OP_DIVF
%right OP_ASSIGN

%%
program
    : stmt
    ;

stmt
    : assignment
    | expression
    | expression_with_semicolon
    | str 
    ;

assignment
    : KW_LET id OP_ASSIGN expression OP_SEMICOLON{
        $$ = Node::add<ast::OpAssignLiteral>($2, $4);
    }
    | KW_LET id OP_COLON type OP_ASSIGN expression OP_SEMICOLON{
        $$ = Node::add<ast::OpAssignTypeAndLiteral>($2, $4, $6);
    }
    | KW_LET id OP_COLON type OP_SEMICOLON{
        $$ = Node::add<ast::OpAssignType>($2, $4);
    }
    ;

id
    : IDENTIFIER { $$ = Node::add<ast::Identifier>(curtoken); }
    ;

expression
    : expression OP_PLUS expression { $$ = Node::add<ast::OpAdd>($1, $3); }
    | expression OP_MINUS expression { $$ = Node::add<ast::OpSub>($1, $3); }
    | term
    ;

expression_with_semicolon
    : expression OP_PLUS expression OP_SEMICOLON { $$ = Node::add<ast::OpAdd2>($1, $3); }
    | expression OP_MINUS expression OP_SEMICOLON { $$ = Node::add<ast::OpSub2>($1, $3); }
    | term_with_semicolon
    ;

term
    : term OP_MULT term { $$ = Node::add<ast::OpMult>($1, $3); }
    | term OP_DIVF term { $$ = Node::add<ast::OpDivF>($1, $3); }
    | factor
    ;

term_with_semicolon
    : term OP_MULT term OP_SEMICOLON { $$ = Node::add<ast::OpMult2>($1, $3); }
    | term OP_DIVF term OP_SEMICOLON { $$ = Node::add<ast::OpDivF2>($1, $3); }
    | factor OP_SEMICOLON { $$ = $1; }
    ;
    
factor
    : posneg
    | OP_LPAREN expression OP_RPAREN { $$ = $2; }
    ;


posneg
    : L_INTEGER { $$ = Node::add<ast::Integer>(curtoken); }
    | OP_PLUS factor { $$ = Node::add<ast::SignedNode>(OP_PLUS, $2); }
    | OP_MINUS factor { $$ = Node::add<ast::SignedNode>(OP_MINUS, $2); }
    ;

type
    : TYPE { $$ = Node::add<ast::Type>(curtoken); }
    ;

str
    : SSTRING OP_SEMICOLON { $$ = Node::add<ast::String>(curtoken); }
    ;
%%

int yyerror(const char *s) {
    if (curtoken) {
        fmt::print("** Parser Error at {}:{} at token: {}\n",
            yylineno, Token::colno, curtoken->as_string());
    } else {
        fmt::print("** Parser Error at {}:{}, null token\n",
            yylineno, Token::colno);
    }
    Token::colno = 0;
    Node::reset_root();
    return 1;
}
