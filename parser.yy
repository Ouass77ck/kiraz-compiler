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
%token KW_IF
%token KW_ELSE
%token IDENTIFIER
%token OP_ASSIGN
%token OP_LPAREN
%token OP_RPAREN
%token OP_LBRACE
%token OP_RBRACE
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
    : assignment OP_SEMICOLON
    | expression OP_SEMICOLON
    | str OP_SEMICOLON
    | ifelse OP_SEMICOLON
    ;

assignment
    : KW_LET id OP_ASSIGN expression {
        $$ = Node::add<ast::OpAssignLiteral>($2, $4);
    }
    | KW_LET id OP_COLON id OP_ASSIGN expression {
        $$ = Node::add<ast::OpAssignTypeAndLiteral>($2, $4, $6);
    }
    | KW_LET id OP_COLON id {
        $$ = Node::add<ast::OpAssignType>($2, $4);
    }
    | id OP_ASSIGN expression {
        $$ = Node::add<ast::OpAssignLiteralWithoutLet>($1, $3);
    }
    ;

ifelse
    : KW_IF OP_LPAREN expression OP_RPAREN OP_LBRACE stmtlist OP_RBRACE {
        $$ = Node::add<ast::OpIfThen>($3, $6);
    }
    | KW_IF OP_LPAREN expression OP_RPAREN OP_LBRACE stmtlist OP_RBRACE KW_ELSE OP_LBRACE stmtlist OP_RBRACE {
        $$ = Node::add<ast::OpIfThenElse>($3, $6, $10);
    }
    ;

stmtlist
    : /* empty */ { $$ = Node::create_list(); }
    | stmtlist stmt { $$ = Node::append_to_list($1, $2); }
    ;

id
    : IDENTIFIER { $$ = Node::add<ast::Identifier>(curtoken); }
    ;

expression
    : expression OP_PLUS term { $$ = Node::add<ast::OpAdd2>($1, $3); }
    | expression OP_MINUS term { $$ = Node::add<ast::OpSub2>($1, $3); }
    | term
    ;

term
    : term OP_MULT factor { $$ = Node::add<ast::OpMult2>($1, $3); }
    | term OP_DIVF factor { $$ = Node::add<ast::OpDivF2>($1, $3); }
    | factor
    ;

factor
    : posneg
    | id
    | OP_LPAREN expression OP_RPAREN { $$ = $2; }
    ;

posneg
    : L_INTEGER { $$ = Node::add<ast::Integer2>(curtoken); }
    | OP_PLUS factor { $$ = Node::add<ast::SignedNode>(OP_PLUS, $2); }
    | OP_MINUS factor { $$ = Node::add<ast::SignedNode>(OP_MINUS, $2); }
    ;

str
    : SSTRING { $$ = Node::add<ast::String>(curtoken); }
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
