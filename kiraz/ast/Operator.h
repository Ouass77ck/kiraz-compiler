#ifndef KIRAZ_AST_OPERATOR_H
#define KIRAZ_AST_OPERATOR_H

#include <cassert>

#include <kiraz/Node.h>

namespace ast {
class OpBinary : public Node {
protected:
    explicit OpBinary(int op, const Node::Ptr &left, const Node::Ptr &right)
    : Node(op), m_left(left), m_right(right) {
        assert(left);
        assert(right);
    }
public:
    auto get_left() const {return m_left; }
    auto get_right() const {return m_right; }
    

    std::string as_string() const override {
        assert(get_left());
        assert(get_right());

        std::string opstr;
        int op_id = get_id();
        switch(op_id) {
            case OP_PLUS:
                opstr = "Add";
                break;
            case OP_MINUS:
                opstr = "Sub";
                break;
            case OP_MULT:
                opstr = "Mult";
                break;
            case OP_DIVF:
                opstr = "DivF";
                break;
            case OP_ASSIGN:
              opstr = "Assign";
            default:
                opstr = "UnknownOp";
                break;
        }
        return fmt::format("{}({},{})",opstr, get_left()->as_string(), get_right()->as_string());
    }
private:
    Node::Ptr m_left, m_right;
};

class OpAdd : public OpBinary {
public:
    OpAdd(const Node::Ptr &left, const Node::Ptr &right) : OpBinary(OP_PLUS, left, right)  {}
};

class OpSub : public OpBinary {
    public:
    OpSub(const Node::Ptr &left, const Node::Ptr &right) : OpBinary(OP_MINUS, left, right)  {}

};

class OpMult : public OpBinary {
    public:
    OpMult(const Node::Ptr &left, const Node::Ptr &right) : OpBinary(OP_MULT, left, right)  {}

};

class OpDivF : public OpBinary {
    public:
    OpDivF(const Node::Ptr &left, const Node::Ptr &right) : OpBinary(OP_DIVF, left, right)  {}

};

class OpAssignLiteral : public Node {
public:
    explicit OpAssignLiteral(const Node::Ptr &left, const Node::Ptr &right)
        : Node(OP_ASSIGN), m_left(left), m_right(right) {
            assert (left);
            assert (right);
        }

    auto get_left() const {return m_left; }
    auto get_right() const {return m_right; }
    std::string as_string() const override {
        assert(get_left());
        assert(get_right());
        return fmt::format("Let(n={}, i={})", get_left()->as_string(), get_right()->as_string());
    }

private:
    Node::Ptr m_left, m_right;
};

class OpAssignType : public Node {

public:
    explicit OpAssignType(const Node::Ptr &left, const Node::Ptr &type)
        : Node(OP_ASSIGN), m_left(left), m_type(type) {
            assert(left);
            assert(type);
        }
    auto get_left() const {return m_left; }
    auto get_type() const {return m_type; }
    std::string as_string() const override {
        assert(get_left());
        assert(get_type());
        return fmt::format("Let(n={}, t={})",get_left()->as_string(), get_type()->as_string());
    }

private:
    Node::Ptr m_left, m_type;
};

class OpAssignTypeAndLiteral : public Node {
public:
    explicit OpAssignTypeAndLiteral(const Node::Ptr &left, const Node::Ptr &type, const Node::Ptr &value)
        : Node(OP_ASSIGN), m_left(left), m_type(type), m_value(value) {
            assert(left);
            assert(type);
            assert(value);  
        }
    auto get_left() const {return m_left; }
    auto get_type() const {return m_type; }
    auto get_value() const {return m_value; }
    std::string as_string() const override {
        assert(get_left());
        assert(get_type());
        assert(get_value());
        return fmt::format("Let(n={}, t={}, i={})", get_left()->as_string(),get_type()->as_string(), get_value()->as_string());
    }

private:
    Node::Ptr m_left,  m_type,  m_value;
};

class OpAssignLiteralWithoutLet : public Node {
public:
    explicit OpAssignLiteralWithoutLet(const Node::Ptr &left, const Node::Ptr &right)
        : Node(OP_ASSIGN), m_left(left), m_right(right) {
            assert (left);
            assert (right);
        }

    auto get_left() const {return m_left; }
    auto get_right() const {return m_right; }
    std::string as_string() const override {
        assert(get_left());
        assert(get_right());
        return fmt::format("Assign(l={}, r={})", get_left()->as_string(), get_right()->as_string());
    }

private:
    Node::Ptr m_left, m_right;
};


class OpBinary2 : public Node {
protected:
    explicit OpBinary2(int op, const Node::Ptr &left, const Node::Ptr &right)
    : Node(op), m_left(left), m_right(right) {
        assert(left);
        assert(right);
    }
public:
    auto get_left() const {return m_left; }
    auto get_right() const {return m_right; }
    

    std::string as_string() const override {
        assert(get_left());
        assert(get_right());

        std::string opstr;
        int op_id = get_id();
        switch(op_id) {
            case OP_PLUS:
                opstr = "Add";
                break;
            case OP_MINUS:
                opstr = "Sub";
                break;
            case OP_MULT:
                opstr = "Mult";
                break;
            case OP_DIVF:
                opstr = "DivF";
                break;
            case OP_ASSIGN:
              opstr = "Assign";
            default:
                opstr = "UnknownOp";
                break;
        }
        return fmt::format("{}(l={}, r={})",opstr, get_left()->as_string(), get_right()->as_string());
    }
private:
    Node::Ptr m_left, m_right;
};



class OpAdd2 : public OpBinary2 {
public:
    OpAdd2(const Node::Ptr &left, const Node::Ptr &right) : OpBinary2(OP_PLUS, left, right)  {}
};

class OpSub2 : public OpBinary2 {
    public:
    OpSub2(const Node::Ptr &left, const Node::Ptr &right) : OpBinary2(OP_MINUS, left, right)  {}

};

class OpMult2 : public OpBinary2 {
    public:
    OpMult2(const Node::Ptr &left, const Node::Ptr &right) : OpBinary2(OP_MULT, left, right)  {}

};

class OpDivF2 : public OpBinary2 {
    public:
    OpDivF2(const Node::Ptr &left, const Node::Ptr &right) : OpBinary2(OP_DIVF, left, right)  {}

};

class OpIfThen : public Node {
public:
    explicit OpIfThen(const Node::Ptr &condition, const Node::Ptr &then_block)
        : Node(KW_IF), m_condition(condition), m_then_block(then_block) {
            assert(condition);
            assert(then_block);
        }

    auto get_condition() const { return m_condition; }
    auto get_then_block() const { return m_then_block; }

    std::string as_string() const override {
        return fmt::format("If(?={}, then=[{}], else=[])", 
                           get_condition()->as_string(), 
                           get_then_block()->as_string());
    }

private:
    Node::Ptr m_condition, m_then_block;
};

class OpIfThenElse : public Node {
public:
    explicit OpIfThenElse(const Node::Ptr &condition, const Node::Ptr &then_block, const Node::Ptr &else_block)
        : Node(KW_IF), m_condition(condition), m_then_block(then_block), m_else_block(else_block) {
            assert(condition);
            assert(then_block);
            assert(else_block);
        }

    auto get_condition() const { return m_condition; }
    auto get_then_block() const { return m_then_block; }
    auto get_else_block() const { return m_else_block; }

    std::string as_string() const override {
        return fmt::format("If(?={}, then=[{}], else=[{}])", 
                           get_condition()->as_string(), 
                           get_then_block()->as_string(), 
                           get_else_block()->as_string());
    }

private:
    Node::Ptr m_condition, m_then_block, m_else_block;
};

class OpWhile : public Node {
public:
    explicit OpWhile(const Node::Ptr &condition, const Node::Ptr &then_block)
        : Node(KW_WHILE), m_condition(condition), m_then_block(then_block) {
            assert(condition);
            assert(then_block);
        }

    auto get_condition() const { return m_condition; }
    auto get_then_block() const { return m_then_block; }

    std::string as_string() const override {
        return fmt::format("While(?={}, repeat=[{}])", 
                           get_condition()->as_string(), 
                           get_then_block()->as_string());
    }

private:
    Node::Ptr m_condition, m_then_block;
};

class OpArg : public Node {
public:
    explicit OpArg(const Node::Ptr &name, const Node::Ptr &type)
        : Node(KW_FUNC), m_name(name), m_type(type) {
            assert(name);
            assert(type);
        }

    auto get_name() const { return m_name; }
    auto get_type() const { return m_type; }

    std::string as_string() const override {
        return fmt::format("FArg(n={}, t={})", 
                           get_name()->as_string(), 
                           get_type()->as_string());
    }

private:
    Node::Ptr m_name, m_type; 
};

class OpFunc : public Node {
public:
    explicit OpFunc(const Node::Ptr &name, const Node::Ptr &args, const Node::Ptr &return_type, const Node::Ptr &body)
        : Node(KW_FUNC),m_name(name), m_args(args), m_return_type(return_type), m_body(body) {
            assert(name);
            assert(args);
            assert(return_type);
            assert(body);
        }

    auto get_name() const { return m_name; }
    auto get_args() const { return m_args; }
    auto get_return_type() const { return m_return_type; }
    auto get_body() const { return m_body; }

    std::string as_string() const override {
        return fmt::format("Func(n={}, a=FuncArgs([{}]), r={}, s=[{}])", 
                           get_name()->as_string(), 
                           get_args()->as_string(), 
                           get_return_type()->as_string(), 
                           get_body()->as_string());
    }

private:
    Node::Ptr m_name, m_args, m_return_type, m_body; 
};

class OpClass : public Node {
public:
    explicit OpClass(const Node::Ptr &name, const Node::Ptr &body)
        : Node(KW_CLASS), m_name(name), m_body(body) {
            assert(name);
            assert(body);
        }

    auto get_name() const { return m_name; }
    auto get_body() const { return m_body; }

    std::string as_string() const override {
        return fmt::format("Class(n={}, s=CStmtList([{}]))", 
                           get_name()->as_string(), 
                           get_body()->as_string());
    }

private:
    Node::Ptr m_name, m_body;
};

class OpImport : public Node {
public:
    explicit OpImport(const Node::Ptr &name)
        : Node(KW_IMPORT), m_name(name) {
            assert(name);
        }

    auto get_name() const { return m_name; }

    std::string as_string() const override {
        return fmt::format("Import({})", 
                           get_name()->as_string());
    }

private:
    Node::Ptr m_name, m_body;
};


}
#endif // KIRAZ_AST_OPERATOR_H
