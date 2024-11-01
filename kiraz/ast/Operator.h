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

class OpAssign : public Node {
public:
    OpAssign(const Node::Ptr &left, const Node::Ptr &right = nullptr) : Node(OP_ASSIGN), m_left(left), m_right(right) {}

    std::string as_string() const override {
        if (m_right) {
            return fmt::format("Assign({}, {})", m_left->as_string(), m_right->as_string());
        }
        return fmt::format("Assign({})", m_left->as_string());
    }

private:
    Node::Ptr m_left, m_right;
};


}
#endif // KIRAZ_AST_OPERATOR_H
