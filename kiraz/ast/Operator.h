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
        return fmt::format("({} = {})", get_left()->as_string(), get_right()->as_string());
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
        return fmt::format("({}: {})",get_left()->as_string(), get_type()->as_string());
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
        return fmt::format("({}: {} = {})", get_left()->as_string(),get_type()->as_string(), get_value()->as_string());
    }

private:
    Node::Ptr m_left,  m_type,  m_value;
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


}
#endif // KIRAZ_AST_OPERATOR_H
