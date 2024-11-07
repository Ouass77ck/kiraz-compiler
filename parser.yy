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
%token KW_WHILE
%token KW_FUNC
%token KW_CLASS
%token KW_IMPORT
%token KW_RETURN
%token IDENTIFIER
%token OP_ASSIGN
%token OP_GT
%token OP_GE
%token OP_LT
%token OP_LE
%token OP_EQ
%token OP_LPAREN
%token OP_RPAREN
%token OP_LBRACE
%token OP_RBRACE
%token OP_PLUS
%token OP_MINUS
%token OP_DIVF
%token OP_MULT
%token OP_DOT
%token OP_COLON
%token OP_COMMA
%token OP_SEMICOLON

%token L_INTEGER
%token TYPE
%token SSTRING
%token REJECTED

%left OP_PLUS OP_MINUS
%left OP_MULT OP_DIVF OP_DOT
%right OP_ASSIGN

%precedence KW_CLASS
%%
all
    :program
    ;
program
    : stmtlist {$$ = Node::add<ast::OpPrgm>($1);}
    ;


stmt
    : assignment OP_SEMICOLON
    | module
    | expression OP_SEMICOLON
    | str OP_SEMICOLON
    | ifelse OP_SEMICOLON
    | while OP_SEMICOLON
    | func OP_SEMICOLON
    | class OP_SEMICOLON
    | import OP_SEMICOLON
    | return OP_SEMICOLON
    | logic OP_SEMICOLON
    | call OP_SEMICOLON
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
return
    : KW_RETURN call {$$ = Node::add<ast::OpReturn>($2);}
    | KW_RETURN logic {$$ = Node::add<ast::OpReturn>($2);}
    | KW_RETURN expression {$$ = Node::add<ast::OpReturn>($2);}
;

logic:
    | expression OP_EQ expression {
        $$ = Node::add<ast::OpEq>($1, $3);
    }
    | expression OP_GT expression {
        $$ = Node::add<ast::OpGt>($1, $3);
    }
    | expression OP_LT expression {
        $$ = Node::add<ast::OpLt>($1, $3);
    }
    | expression OP_GE expression {
        $$ = Node::add<ast::OpGe>($1, $3);
    }
    | expression OP_LE expression {
        $$ = Node::add<ast::OpLe>($1, $3);
    };
ifelse
    : KW_IF OP_LPAREN expression OP_RPAREN OP_LBRACE stmtlist OP_RBRACE {
        $$ = Node::add<ast::OpIfThen>($3, $6);
    }
    | KW_IF OP_LPAREN expression OP_RPAREN OP_LBRACE stmtlist OP_RBRACE KW_ELSE OP_LBRACE stmtlist OP_RBRACE {
        $$ = Node::add<ast::OpIfThenElse>($3, $6, $10);
    }
    ;

while
    : KW_WHILE OP_LPAREN expression OP_RPAREN OP_LBRACE stmtlist OP_RBRACE {
        $$ = Node::add<ast::OpWhile>($3, $6);
    };
    | KW_WHILE OP_LPAREN logic OP_RPAREN OP_LBRACE stmtlist OP_RBRACE {
        $$ = Node::add<ast::OpWhile>($3, $6);
    };

func
    : KW_FUNC id OP_LPAREN argslist OP_RPAREN OP_COLON id OP_LBRACE stmtlist OP_RBRACE {
        $$ = Node::add<ast::OpFunc>($2, $4, $7, $9);
    }
    ;
class
    : KW_CLASS id OP_LBRACE stmtlist OP_RBRACE{
        $$ = Node::add<ast::OpClass>($2, $4);
    }
    ;
import
    : KW_IMPORT id {$$ = Node::add<ast::OpImport>($2);
    };

module
    : import OP_COMMA class OP_SEMICOLON {$$ = Node::add<ast::OpModule>($1, $3);
    };

stmtlist
    : /* empty */ { $$ = Node::create_list(); }
    | stmtlist stmt { $$ = Node::append_to_list($1, $2); }
    ;

argslist
    : /* empty */ { $$ = Node::create_list(); }
    | argslist OP_COMMA arg { $$ = Node::append_to_list($1, $3); }
    | arg { $$ = Node::append_to_list(Node::create_list(), $1); }
    ;

arg
    : id OP_COLON id { $$ = Node::add<ast::OpArg>($1, $3); }
    ;
idslist
    : /* empty */ { $$ = Node::create_list(); }
    | idslist OP_COMMA id { $$ = Node::append_to_list($1, $3); }
    | id { $$ = Node::append_to_list(Node::create_list(), $1); }
    ;
id
    : IDENTIFIER { $$ = Node::add<ast::Identifier>(curtoken); }
    ;

call
    : dot OP_LPAREN idslist OP_RPAREN { $$ = Node::add<ast::OpCall>($1, $3); }
    ;


dot
    :id OP_DOT id { $$ = Node::add<ast::OpDot>($1, $3); }
    |id OP_DOT id OP_DOT id{ $$ = Node::add<ast::OpDot>(($$ = Node::add<ast::OpDot>($1, $3)), $5) ; }
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
    : L_INTEGER { $$ = Node::add<ast::Integer>(curtoken); }
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
