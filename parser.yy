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
    | str 
    ;

assignment
    : KW_LET id OP_ASSIGN expression {
        printf("Token received for IDENTIFIER: %s\n", $2 ? "non-null" : "null");
        assert($2 != nullptr);
        assert($4 != nullptr);
        printf("ID: %s\n", $2->as_string().c_str());
        $$ = Node::add<ast::OpAssignLiteral>($2, $4);
    }
    | KW_LET id OP_COLON type OP_ASSIGN expression {
        $$ = Node::add<ast::OpAssignTypeAndLiteral>($2, $4, $6);
    }
    | KW_LET id OP_COLON type {
        $$ = Node::add<ast::OpAssignType>($2, $4);
    }
    ;

id
    : IDENTIFIER { $$ = Node::add<ast::Identifier>(curtoken); }
    ;

expression
    : term
    | expression OP_PLUS term { $$ = Node::add<ast::OpAdd>($1, $3); }
    | expression OP_MINUS term { $$ = Node::add<ast::OpSub>($1, $3); }
    ;

term
    : factor
    | term OP_MULT factor { $$ = Node::add<ast::OpMult>($1, $3); }
    | term OP_DIVF factor { $$ = Node::add<ast::OpDivF>($1, $3); }
    ;

factor
    : posneg
    | OP_LPAREN expression OP_RPAREN { $$ = $2; }
    ;

posneg
    : L_INTEGER { $$ = Node::add<ast::Integer>(curtoken); }
    | OP_PLUS expression { $$ = Node::add<ast::SignedNode>(OP_PLUS, $2); }
    | OP_MINUS expression { $$ = Node::add<ast::SignedNode>(OP_MINUS, $2); }
    ;

type
    : TYPE { $$ = Node::add<ast::Type>(curtoken); }
    ;

str
    : SSTRING OP_SEMICOLON {$$ = Node::add<ast::String>(curtoken);}
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
